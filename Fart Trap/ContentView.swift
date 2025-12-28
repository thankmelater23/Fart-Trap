//
//  ContentView.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 12/28/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var watchManager: WatchConnectivityManager
    @State private var showTimer = false
    @State private var showInfo = false
    
    var body: some View {
        TabView {
            // Main Fart View
            FartsView()
                .environmentObject(audioManager)
                .tabItem {
                    Label("Farts", systemImage: "wind")
                }
            
            // Sounds List View
            SoundsListView()
                .environmentObject(audioManager)
                .tabItem {
                    Label("Sounds", systemImage: "list.bullet")
                }
            
            // Timer View
            TimerView()
                .environmentObject(audioManager)
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
            
            // Settings/Info View
            InfoView()
                .environmentObject(watchManager)
                .tabItem {
                    Label("Info", systemImage: "info.circle")
                }
        }
        .accentColor(.green)
    }
}

// MARK: - Farts View

struct FartsView: View {
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        ZStack {
            // Background gradient with subtle animation when playing
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: audioManager.isPlaying ? 0.9 : 0.8, blue: 0.0),
                    Color(red: 0.0, green: 1.0, blue: 0.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .animation(.easeInOut(duration: 0.3), value: audioManager.isPlaying)
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
                    FartButton(title: "💨 Short Fart", color: .orange) {
                        audioManager.playFart(category: .short)
                    }
                    
                    FartButton(title: "💨💨 Medium Fart", color: .orange) {
                        audioManager.playFart(category: .medium)
                    }
                    
                    FartButton(title: "💨💨💨 Long Fart", color: .orange) {
                        audioManager.playFart(category: .long)
                    }
                    
                    FartButton(title: "🎲 Random Fart", color: .orange) {
                        audioManager.playFart(category: .random)
                    }
                    
                    // Replay Last Button
                    if audioManager.lastPlayedSound != nil {
                        FartButton(title: "🔁 Replay Last", color: .blue) {
                            audioManager.replayLastSound()
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

// MARK: - Fart Button

struct FartButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        Button(action: {
            // Instant haptic feedback (pre-prepared)
            impactGenerator.impactOccurred()
            
            // Instant action
            action()
            
            // Visual feedback
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation {
                    isPressed = false
                }
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
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            // Prepare haptic generator for instant feedback
            impactGenerator.prepare()
        }
    }
}

// MARK: - Sounds List View

struct SoundsListView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State private var allSounds: [String] = []
    @State private var searchText = ""
    
    var filteredSounds: [String] {
        if searchText.isEmpty {
            return allSounds
        }
        return allSounds.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ZStack {
            // Background gradient - darker for better contrast
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.5, blue: 0.0),
                    Color(red: 0.0, green: 0.7, blue: 0.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("All Fart Sounds")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                        .padding(.top, 20)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("Search sounds...", text: $searchText)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.2))
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
                
                // Sounds List
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(filteredSounds, id: \.self) { soundName in
                            SoundListRow(soundName: soundName) {
                                audioManager.playSound(named: soundName)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            loadSounds()
        }
    }
    
    private func loadSounds() {
        let generator = FartGenerator()
        allSounds = generator.getAllFartSounds()
        print("📋 Loaded \(allSounds.count) fart sounds")
    }
}

// MARK: - Sound List Row

struct SoundListRow: View {
    let soundName: String
    let action: () -> Void
    
    @State private var isPressed = false
    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        Button(action: {
            impactGenerator.impactOccurred()
            action()
            
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation {
                    isPressed = false
                }
            }
        }) {
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .frame(width: 30)
                
                Text(soundName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                
                Spacer()
                
                Image(systemName: "play.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(isPressed ? 0.4 : 0.3))
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            impactGenerator.prepare()
        }
    }
}

// MARK: - Info View

struct InfoView: View {
    @EnvironmentObject var watchManager: WatchConnectivityManager
    
    var body: some View {
        ZStack {
            // Background gradient - darker for better contrast
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.5, blue: 0.0),
                    Color(red: 0.0, green: 0.7, blue: 0.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // App Icon and Title
                    VStack(spacing: 10) {
                        Image(systemName: "wind")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                        
                        Text("Fart Trap")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                        
                        Text("Version 2.0")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                    .padding(.top, 40)
                    
                    // How to Use
                    InfoCard(
                        icon: "hand.tap.fill",
                        title: "How to Use",
                        description: "Tap any fart button to play that category of sound. Use the Timer tab to set delayed or repeating farts!"
                    )
                    
                    // Watch Control
                    InfoCard(
                        icon: "applewatch",
                        title: "Apple Watch Remote",
                        description: "Control farts from your Apple Watch! Keep the app open on your iPhone and use your Watch to trigger sounds remotely."
                    )
                    
                    // Watch Status
                    HStack(spacing: 12) {
                        Image(systemName: watchManager.isWatchConnected ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(watchManager.isWatchConnected ? .green : .red)
                            .font(.system(size: 24))
                        Text(watchManager.isWatchConnected ? "Watch Connected" : "Watch Not Connected")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.3))
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
                    
                    // Tips
                    InfoCard(
                        icon: "lightbulb.fill",
                        title: "Pro Tip",
                        description: "For best results, keep your ringer on and the app in the foreground. Hide your phone and use your Watch for the ultimate prank!"
                    )
                    
                    // Credits
                    VStack(spacing: 5) {
                        Text("Bang Bang Studios")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("© 2024 All Rights Reserved")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Info Card

struct InfoCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 50)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.4))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(AudioManager())
        .environmentObject(WatchConnectivityManager.shared)
}
