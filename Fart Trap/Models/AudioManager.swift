//
//  AudioManager.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 12/28/24.
//  Copyright © 2024 Bang Bang Studios. All rights reserved.
//

import AVFoundation
import Combine
import Foundation

// MARK: - Audio Manager

@available(iOS 13.0, *)
class AudioManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentFartName: String = "Select a Fart"
    @Published var isPlaying: Bool = false
    @Published var lastPlayedSound: String? = nil
    
    // MARK: - Private Properties
    
    private var audioPlayer: AVAudioPlayer?
    private let fartGenerator = FartGenerator()
    private var preloadedPlayers: [String: AVAudioPlayer] = [:]
    
    // MARK: - Initialization
    
    init() {
        configureAudioSession()
        preloadAudioFiles()
    }
    
    // MARK: - Audio Preloading
    
    private func preloadAudioFiles() {
        print("🔄 Preloading audio files...")
        
        // Preload a few common sounds for instant playback
        let soundsToPreload = ["Quick Fart", "Sharp Fart", "Long Fart", "Person Farting"]
        
        for soundName in soundsToPreload {
            if let soundPath = Bundle.main.path(forResource: soundName, ofType: "mp3") {
                let soundURL = URL(fileURLWithPath: soundPath)
                if let player = try? AVAudioPlayer(contentsOf: soundURL) {
                    player.prepareToPlay()
                    preloadedPlayers[soundName] = player
                }
            }
        }
        
        print("✅ Preloaded \(preloadedPlayers.count) sounds for instant playback")
    }
    
    // MARK: - Audio Session Configuration
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // Configure for background playback
            // This allows sounds to play even when app is in background
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
            print("🔊 Audio session configured for background playback")
        } catch {
            print("⚠️ Audio session configuration failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Public Methods
    
    func playFart(category: FartCategory) {
        print("💨 Category selected: \(category.rawValue)")
        
        let soundName: String
        
        switch category {
        case .short:
            soundName = fartGenerator.randomShortFartChoser()
        case .medium:
            soundName = fartGenerator.randomMediumFartChoser()
        case .long:
            soundName = fartGenerator.randomLongFartChoser()
        case .random:
            soundName = fartGenerator.randomFartChoser()
        }
        
        playSound(named: soundName)
    }
    
    func playSound(named name: String) {
        print("🎵 Playing: \(name)")
        
        // Track last played sound
        lastPlayedSound = name
        
        // Update UI immediately
        currentFartName = name
        isPlaying = true
        
        // Stop current playback if playing
        if let player = audioPlayer, player.isPlaying {
            player.stop()
        }
        
        // Try to use preloaded player first for instant playback
        if let preloadedPlayer = preloadedPlayers[name] {
            print("⚡ Using preloaded audio")
            preloadedPlayer.currentTime = 0 // Reset to start
            preloadedPlayer.play()
            audioPlayer = preloadedPlayer
            
            let duration = preloadedPlayer.duration
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.isPlaying = false
            }
            print("✅ Fart playing successfully")
            return
        }
        
        // Otherwise, load and play normally
        guard let soundPath = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("❌ Error: Audio file '\(name).mp3' not found")
            isPlaying = false
            return
        }
        
        let soundURL = URL(fileURLWithPath: soundPath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
            
            print("✅ Fart playing successfully")
            
            let duration = audioPlayer?.duration ?? 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.isPlaying = false
            }
        } catch {
            print("❌ Error playing audio: \(error.localizedDescription)")
            isPlaying = false
        }
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        DispatchQueue.main.async { [weak self] in
            self?.isPlaying = false
        }
    }
    
    // MARK: - Replay Last Sound
    
    func replayLastSound() {
        guard let lastSound = lastPlayedSound else {
            print("⚠️ No sound to replay")
            return
        }
        print("🔁 Replaying: \(lastSound)")
        playSound(named: lastSound)
    }
    
    // MARK: - Legacy Support (for FartTimer)
    
    func shortFartButtonPressed() {
        playFart(category: .short)
    }
    
    func mediumFartButtonPressed() {
        playFart(category: .medium)
    }
    
    func longFartButtonPressed() {
        playFart(category: .long)
    }
    
    func playRandomFartSound() {
        playFart(category: .random)
    }
}


