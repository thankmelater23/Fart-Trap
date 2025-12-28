//
//  FartTrapView.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 12/27/25.
//  Copyright © 2025 Bang Bang Studios. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 13.0, *)
struct FartTrapView: View {
    @StateObject private var audioManager = AudioManager()
    @StateObject private var viewModel = FartTrapViewModel()
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.8, blue: 0.0),
                    Color(red: 0.0, green: 1.0, blue: 0.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Fart Trap")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                    
                    Text(audioManager.currentFartName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.4, green: 0.8, blue: 1.0))
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Fart Buttons
                VStack(spacing: 16) {
                    LegacyFartButton(title: "💨 Short Fart", color: .orange) {
                        audioManager.playFart(category: .short)
                    }
                    
                    LegacyFartButton(title: "💨💨 Medium Fart", color: .orange) {
                        audioManager.playFart(category: .medium)
                    }
                    
                    LegacyFartButton(title: "💨💨💨 Long Fart", color: .orange) {
                        audioManager.playFart(category: .long)
                    }
                    
                    LegacyFartButton(title: "🎲 Random Fart", color: .orange) {
                        audioManager.playFart(category: .random)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Info Button
                Button(action: {
                    viewModel.showInfo = true
                }) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text("How to Use")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.3))
                    )
                }
                .padding(.bottom, 30)
            }
        }
        .alert("Welcome to Fart Trap! 💨", isPresented: $viewModel.showInfo) {
            Button("Got It!", role: .cancel) { }
        } message: {
            Text("Keep the app in the foreground with the ringer on to enjoy maximum fart entertainment. Use your Apple Watch to prank friends remotely!")
        }
    }
}

@available(iOS 13.0, *)
struct LegacyFartButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            isPressed = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }) {
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 75)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(color)
                        .shadow(color: .black.opacity(isPressed ? 0.1 : 0.3), radius: isPressed ? 2 : 8, x: 0, y: isPressed ? 1 : 4)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

@available(iOS 13.0, *)
class FartTrapViewModel: ObservableObject {
    @Published var showInfo = false
}

@available(iOS 13.0, *)
struct FartTrapView_Previews: PreviewProvider {
    static var previews: some View {
        FartTrapView()
    }
}

