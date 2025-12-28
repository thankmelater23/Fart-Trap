//
//  FartTimer.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 12/28/24.
//  Copyright © 2024 Bang Bang Studios. All rights reserved.
//

import Foundation

// MARK: - Timer Delegate Protocol

protocol FartTimerDelegate: AnyObject {
    func timerDidTick(secondsRemaining: Int)
    func timerWillPlayFart()
    func timerDidComplete()
    func timerDidCancel()
}

// MARK: - Fart Timer Mode

enum FartTimerMode {
    case single      // Play once after delay
    case repeating   // Repeat at intervals
}

// MARK: - Fart Timer Manager

@available(iOS 13.0, *)
class FartTimer {
    
    // MARK: - Properties
    
    weak var delegate: FartTimerDelegate?
    private var timer: Timer?
    private var countdown: Int = 0
    private var initialDelay: Int = 0
    private var repeatInterval: Int = 0
    private var mode: FartTimerMode = .single
    private var category: FartCategory = .random
    private var audioManager: AudioManager
    private var isActive = false
    
    // MARK: - Initialization
    
    init(audioManager: AudioManager = AudioManager()) {
        self.audioManager = audioManager
    }
    
    // MARK: - Public Methods
    
    /// Start a single timer
    func startSingleTimer(delay: Int, category: FartCategory = .random) {
        print("⏰ Starting single timer: \(delay)s, category: \(category.rawValue)")
        stopTimer()
        
        self.mode = .single
        self.category = category
        self.initialDelay = delay
        self.countdown = delay
        self.isActive = true
        
        startCountdown()
    }
    
    /// Start a repeating timer
    func startRepeatingTimer(interval: Int, category: FartCategory = .random) {
        print("🔁 Starting repeat timer: \(interval)s, category: \(category.rawValue)")
        stopTimer()
        
        self.mode = .repeating
        self.category = category
        self.repeatInterval = interval
        self.countdown = interval
        self.isActive = true
        
        startCountdown()
    }
    
    /// Stop the timer
    func stopTimer() {
        guard isActive else {
            print("⚠️ stopTimer called but timer wasn't active")
            return
        }
        
        print("🛑 Stopping FartTimer (isActive: \(isActive))")
        timer?.invalidate()
        timer = nil
        isActive = false
        countdown = 0
        // Don't call delegate here - let the viewmodel handle state
    }
    
    /// Check if timer is running
    func isRunning() -> Bool {
        return isActive
    }
    
    /// Get remaining seconds
    func getRemainingSeconds() -> Int {
        return countdown
    }
    
    // MARK: - Private Methods
    
    private func startCountdown() {
        timer?.invalidate()
        
        // Ensure timer runs on main run loop
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        
        // Add timer to main run loop to ensure it persists
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    private func tick() {
        countdown -= 1
        delegate?.timerDidTick(secondsRemaining: countdown)
        
        if countdown <= 0 {
            print("⏰ Timer fired! Playing fart...")
            playFartForCategory()
            
            switch mode {
            case .single:
                print("⏰ Single timer complete")
                stopTimer()
                delegate?.timerDidComplete()
            case .repeating:
                print("🔁 Repeating - resetting to \(repeatInterval)s")
                // Reset countdown for next iteration
                countdown = repeatInterval
                delegate?.timerDidTick(secondsRemaining: countdown)
            }
        }
    }
    
    private func playFartForCategory() {
        delegate?.timerWillPlayFart()
        print("⏰ Timer playing category: \(category.rawValue)")
        audioManager.playFart(category: category)
    }
}

// MARK: - Timer Helper Extensions

extension FartTimer {
    
    /// Format seconds to readable time string
    static func formatTime(seconds: Int) -> String {
        if seconds >= 60 {
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            return String(format: "%d:%02d", minutes, remainingSeconds)
        } else {
            return "\(seconds)s"
        }
    }
    
    /// Get preset intervals
    static func getPresetIntervals() -> [(name: String, seconds: Int)] {
        return [
            ("5 seconds", 5),
            ("10 seconds", 10),
            ("15 seconds", 15),
            ("30 seconds", 30),
            ("1 minute", 60),
            ("2 minutes", 120),
            ("5 minutes", 300)
        ]
    }
}
