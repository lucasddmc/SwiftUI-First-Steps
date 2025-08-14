import Foundation
import AVFoundation
import CoreML

class AudioClassifier: ObservableObject {
    @Published var isRecording = false
    @Published var currentClassification = "Not listening"
    @Published var confidence: Float = 0.0
    @Published var error: String?
    @Published var audioLevel: Float = 0.0
    @Published var isReceivingAudio = false
    
    private var audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode!
    private var audioBuffer: AVAudioPCMBuffer?
    private var model: SentimentSoundModel?
    private var isTapInstalled = false
    
    // Audio accumulation for proper model input
    private var accumulatedAudio: [Float] = []
    private let targetSampleRate: Double = 16000
    private let audioDurationSeconds: Double = 2.0 // 2 seconds of audio for classification
    private var targetSampleCount: Int { Int(targetSampleRate * audioDurationSeconds) }
    
    init() {
        loadModel()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(false)
        } catch {
            DispatchQueue.main.async {
                self.error = "Audio session setup failed: \(error.localizedDescription)"
            }
        }
    }
    
    private func setupAudioEngine() -> Bool {
        // Reset the engine if it's already configured
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        
        inputNode = audioEngine.inputNode
        
        // Validate the input format before proceeding
        let inputFormat = inputNode.outputFormat(forBus: 0)
        
        guard inputFormat.sampleRate > 0 && inputFormat.channelCount > 0 else {
            DispatchQueue.main.async {
                self.error = "Invalid audio input format - check microphone availability"
            }
            return false
        }
        
        // Only install tap if not already installed
        if !isTapInstalled {
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { [weak self] buffer, _ in
                self?.processAudioBuffer(buffer)
            }
            isTapInstalled = true
        }
        
        return true
    }
    
    private func loadModel() {
        do {
            model = try SentimentSoundModel(configuration: MLModelConfiguration())
        } catch {
            self.error = "Failed to load model: \(error.localizedDescription)"
        }
    }
    
    func startRecording() {
        guard !audioEngine.isRunning else { return }
        
        do {
            // Activate audio session
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(true)
            
            // Setup audio engine with validation
            guard setupAudioEngine() else {
                return // Error already set in setupAudioEngine
            }
            
            // Prepare and start the engine
            audioEngine.prepare()
            try audioEngine.start()
            
            DispatchQueue.main.async {
                self.isRecording = true
                self.error = nil
                self.accumulatedAudio.removeAll()
                self.currentClassification = "Listening..."
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "Failed to start recording: \(error.localizedDescription)"
            }
        }
    }
    
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        
        if isTapInstalled {
            inputNode.removeTap(onBus: 0)
            isTapInstalled = false
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Failed to deactivate audio session: \(error)")
        }
        
        DispatchQueue.main.async {
            self.isRecording = false
            self.currentClassification = "Not listening"
            self.confidence = 0.0
            self.audioLevel = 0.0
            self.isReceivingAudio = false
        }
    }
    
    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let model = model else { return }
        
        // Convert buffer to the format expected by the model (16kHz mono)
        let resampledData = convertBufferToModelFormat(buffer)
        
        // Calculate real-time audio level for UI feedback
        let rms = calculateRMS(from: resampledData)
        let dbLevel = 20 * log10(rms + 0.000001) // Add small value to avoid log(0)
        let normalizedLevel = max(0, min(1, (dbLevel + 60) / 60)) // Normalize -60dB to 0dB range
        
        DispatchQueue.main.async {
            self.audioLevel = normalizedLevel
            self.isReceivingAudio = rms > 0.001 // Threshold for detecting audio input
        }
        
        // Accumulate audio data
        accumulatedAudio.append(contentsOf: resampledData)
        
        // Only classify when we have enough audio (2 seconds)
        if accumulatedAudio.count >= targetSampleCount {
            // Take the last 2 seconds of audio
            let audioForClassification = Array(accumulatedAudio.suffix(targetSampleCount))
            
            // Debug: Check audio levels
            let avgLevel = audioForClassification.reduce(0, +) / Float(audioForClassification.count)
            let maxLevel = audioForClassification.max() ?? 0
            
            print("Audio Debug - Samples: \(audioForClassification.count), Avg: \(avgLevel), Max: \(maxLevel), RMS: \(rms)")
            
            do {
                let multiArray = try MLMultiArray(shape: [NSNumber(value: audioForClassification.count)], dataType: .float32)
                
                for (index, sample) in audioForClassification.enumerated() {
                    multiArray[index] = NSNumber(value: sample)
                }
                
                let input = SentimentSoundModelInput(audioSamples: multiArray)
                let prediction = try model.prediction(input: input)
                
                print("Prediction: \(prediction.target), All probabilities: \(prediction.targetProbability)")
                
                DispatchQueue.main.async {
                    self.currentClassification = prediction.target
                    if let probabilities = prediction.targetProbability[prediction.target] {
                        self.confidence = Float(probabilities)
                    }
                }
                
                // Keep only the last 1 second to avoid too much overlap
                let keepSamples = Int(targetSampleRate * 1.0)
                if accumulatedAudio.count > keepSamples {
                    accumulatedAudio = Array(accumulatedAudio.suffix(keepSamples))
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.error = "Classification error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func calculateRMS(from samples: [Float]) -> Float {
        guard !samples.isEmpty else { return 0 }
        let sum = samples.map { $0 * $0 }.reduce(0, +)
        return sqrt(sum / Float(samples.count))
    }
    
    private func convertBufferToModelFormat(_ buffer: AVAudioPCMBuffer) -> [Float] {
        guard let floatData = buffer.floatChannelData?[0] else { return [] }
        
        let frameLength = Int(buffer.frameLength)
        let inputSampleRate = buffer.format.sampleRate
        let targetSampleRate: Double = 16000
        
        // If already at 16kHz, just return the data
        if abs(inputSampleRate - targetSampleRate) < 100 {
            return Array(UnsafeBufferPointer(start: floatData, count: frameLength))
        }
        
        // Simple downsampling - take every nth sample
        let ratio = inputSampleRate / targetSampleRate
        var resampledData: [Float] = []
        
        var sourceIndex: Double = 0
        while Int(sourceIndex) < frameLength {
            resampledData.append(floatData[Int(sourceIndex)])
            sourceIndex += ratio
        }
        
        return resampledData
    }
}
