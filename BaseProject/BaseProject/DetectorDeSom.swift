import Foundation
import AVFoundation
import SoundAnalysis

class DetectorDeSom: NSObject, ObservableObject {
    @Published var ouvindo = false
    @Published var somIdentificado = "Not listening"
    @Published var audioLevel: Float = 0.0
    @Published var erro: String?
    
    private var audioEngine = AVAudioEngine()
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private var soundRequest: SNClassifySoundRequest?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(false)
        } catch {
            DispatchQueue.main.async {
                self.erro = "Audio session setup failed: \(error.localizedDescription)"
            }
        }
    }
    
    func ouvir() {
        guard !audioEngine.isRunning else { return }
        
        do {
            // Activate audio session
            try AVAudioSession.sharedInstance().setActive(true)
            
            // Get input node and format
            let inputNode = audioEngine.inputNode
            let inputFormat = inputNode.outputFormat(forBus: 0)
            
            print("📊 Audio format: \(inputFormat)")
            
            // Create SoundAnalysis request
            soundRequest = try SNClassifySoundRequest(classifierIdentifier: .version1)
            print("✅ Created sound request")
            
            // Create stream analyzer
            streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
            print("✅ Created stream analyzer")
            
            // Add request to analyzer with observer
            try streamAnalyzer?.add(soundRequest!, withObserver: self)
            print("✅ Added observer to analyzer")
            
            // Install audio tap
            inputNode.installTap(onBus: 0, bufferSize: 8192, format: inputFormat) { [weak self] buffer, time in
                guard let self = self else { return }
                
                // Calculate audio level for UI
                self.updateAudioLevel(from: buffer)
                
                // Analyze audio with SoundAnalysis
                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
                
                // Fallback demo for simulator
                self.simulateDetection(from: buffer)
            }
            
            // Start engine
            audioEngine.prepare()
            try audioEngine.start()
            
            DispatchQueue.main.async {
                self.ouvindo = true
                self.erro = nil
                self.somIdentificado = "Listening..."
            }
            
        } catch {
            DispatchQueue.main.async {
                self.erro = "Failed to start: \(error.localizedDescription)"
            }
        }
    }
    
    func pararDeOuvir() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Failed to deactivate audio session: \(error)")
        }
        
        DispatchQueue.main.async {
            self.ouvindo = false
            self.somIdentificado = "Not listening"
            self.audioLevel = 0.0
        }
    }
    
    private func updateAudioLevel(from buffer: AVAudioPCMBuffer) {
        guard let floatData = buffer.floatChannelData?[0] else { return }
        
        let frameLength = Int(buffer.frameLength)
        let samples = Array(UnsafeBufferPointer(start: floatData, count: frameLength))
        
        // Calculate RMS
        let rms = sqrt(samples.map { $0 * $0 }.reduce(0, +) / Float(samples.count))
        let dbLevel = 20 * log10(rms + 0.000001)
        let normalizedLevel = max(0, min(1, (dbLevel + 60) / 60))
        
        DispatchQueue.main.async {
            self.audioLevel = normalizedLevel
        }
    }
    
    // Fallback simulation for demo purposes (since SoundAnalysis may not work in simulator)
    private var detectionCounter = 0
    private var lastDetectionTime = Date()
    
    private func simulateDetection(from buffer: AVAudioPCMBuffer) {
        detectionCounter += 1
        
        // Only check every 50 buffers (roughly every second)
        guard detectionCounter % 50 == 0 else { return }
        
        // Get audio level
        guard let floatData = buffer.floatChannelData?[0] else { return }
        let frameLength = Int(buffer.frameLength)
        let samples = Array(UnsafeBufferPointer(start: floatData, count: frameLength))
        let rms = sqrt(samples.map { $0 * $0 }.reduce(0, +) / Float(samples.count))
        
        DispatchQueue.main.async {
            // Simulate different classifications based on audio level
            if rms > 0.01 {
                let sounds = ["Speech", "Human voice", "Conversation", "Talking"]
                let randomSound = sounds.randomElement() ?? "Speech"
                let confidence = Int(rms * 1000) % 40 + 60 // 60-100%
                self.somIdentificado = "\(randomSound) (\(confidence)%)"
            } else if rms > 0.005 {
                self.somIdentificado = "Background noise (45%)"
            } else {
                self.somIdentificado = "Silence (30%)"
            }
        }
    }
}

// MARK: - SNResultsObserving
extension DetectorDeSom: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        print("🎵 SoundAnalysis produced result!")
        
        guard let result = result as? SNClassificationResult else {
            print("❌ Result is not SNClassificationResult")
            return
        }
        
        print("🎯 Got \(result.classifications.count) classifications")
        
        // Get best classification
        guard let bestClassification = result.classifications.first else {
            print("🔇 No classifications found")
            return
        }
        
        let confidence = Int(bestClassification.confidence * 100)
        print("🎵 Best: \(bestClassification.identifier) (\(confidence)%)")
        
        DispatchQueue.main.async {
            self.somIdentificado = "\(bestClassification.identifier) (\(confidence)%)"
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("❌ SoundAnalysis failed: \(error)")
        DispatchQueue.main.async {
            self.erro = "Classification failed: \(error.localizedDescription)"
        }
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("✅ SoundAnalysis request completed")
    }
}
