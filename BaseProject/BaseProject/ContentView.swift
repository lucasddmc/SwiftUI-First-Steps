//
//  ContentView.swift
//  BaseProject
//
//  Created by admin on 13/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var soundAnalyzer = SimpleSoundClassifier()
    
    var body: some View {
        VStack(spacing: 40) {
            // Header
            VStack(spacing: 10) {
                Text("🎵 Apple SoundAnalysis")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("AI-powered sound recognition with 300+ categories")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            // Main detection display
            VStack(spacing: 20) {
                Text("I can hear:")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text(soundAnalyzer.currentTopSound)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(soundAnalyzer.isListening ? .primary : .gray)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 80)
                    .animation(.easeInOut(duration: 0.3), value: soundAnalyzer.currentTopSound)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            
            // Audio visualization
            if soundAnalyzer.isListening {
                VStack(spacing: 10) {
                    Text("Audio Level")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)
                            
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.green, .yellow, .red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * CGFloat(soundAnalyzer.audioLevel), height: 8)
                                .animation(.easeInOut(duration: 0.1), value: soundAnalyzer.audioLevel)
                        }
                    }
                    .frame(height: 8)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Action button
            Button(action: {
                if soundAnalyzer.isListening {
                    soundAnalyzer.stopListening()
                } else {
                    soundAnalyzer.startListening()
                }
            }) {
                HStack(spacing: 15) {
                    Image(systemName: soundAnalyzer.isListening ? "stop.circle.fill" : "waveform.circle.fill")
                        .font(.title)
                    
                    Text(soundAnalyzer.isListening ? "Stop Listening" : "Start Sound Detection")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(
                    Capsule()
                        .fill(soundAnalyzer.isListening ? 
                              LinearGradient(colors: [.red, .pink], startPoint: .leading, endPoint: .trailing) :
                              LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                        )
                )
                .scaleEffect(soundAnalyzer.isListening ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: soundAnalyzer.isListening)
            }
            
            // Demo instructions
            if !soundAnalyzer.isListening {
                VStack(spacing: 8) {
                    Text("Try these sounds:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("👏 Clap • 🗣️ Talk • ⌨️ Type • 🎵 Play music")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            // Error display
            if let error = soundAnalyzer.error {
                Text("⚠️ \(error)")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color(.systemGray6), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
