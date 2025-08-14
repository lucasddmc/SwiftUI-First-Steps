//
//  ContentView.swift
//  BaseProject
//
//  Created by admin on 13/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var audioClassifier = AudioClassifier()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Audio Sentiment Classifier")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                Text("Classification:")
                    .font(.headline)
                
                Text(audioClassifier.currentClassification)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(audioClassifier.isRecording ? .blue : .gray)
                
                if audioClassifier.confidence > 0 {
                    Text("Confidence: \(String(format: "%.1f%%", audioClassifier.confidence * 100))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Audio level indicator
                if audioClassifier.isRecording {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Audio Input:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Circle()
                                .fill(audioClassifier.isReceivingAudio ? .green : .red)
                                .frame(width: 8, height: 8)
                            
                            Text(audioClassifier.isReceivingAudio ? "Detected" : "No Signal")
                                .font(.caption)
                                .foregroundColor(audioClassifier.isReceivingAudio ? .green : .red)
                        }
                        
                        // Audio level bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 4)
                                
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: geometry.size.width * CGFloat(audioClassifier.audioLevel), height: 4)
                                    .animation(.easeInOut(duration: 0.1), value: audioClassifier.audioLevel)
                            }
                        }
                        .frame(height: 4)
                        
                        Text("Level: \(String(format: "%.1f%%", audioClassifier.audioLevel * 100))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Button(action: {
                if audioClassifier.isRecording {
                    audioClassifier.stopRecording()
                } else {
                    audioClassifier.startRecording()
                }
            }) {
                HStack {
                    Image(systemName: audioClassifier.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .font(.title2)
                    Text(audioClassifier.isRecording ? "Stop Listening" : "Start Listening")
                        .fontWeight(.semibold)
                }
                .padding()
                .background(audioClassifier.isRecording ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            if let error = audioClassifier.error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
