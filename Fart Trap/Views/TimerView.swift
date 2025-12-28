//
//  TimerView.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 12/28/24.
//  Copyright © 2024 Bang Bang Studios. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 13.0, *)
struct TimerView: View {
    @EnvironmentObject var audioManager: AudioManager
    @StateObject private var viewModel = TimerViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.6, blue: 0.0),
                    Color(red: 0.0, green: 0.8, blue: 0.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Spacer()
                    
                    Text("⏰ Fart Timer")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.top)
                
                // Timer Display
                if viewModel.isTimerRunning {
                    VStack(spacing: 15) {
                        Text("Next fart in:")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                        
                        Text(viewModel.timeDisplay)
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                            .monospacedDigit()
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                        
                        // Mode indicator
                        if viewModel.timerMode == 1 {
                            Text("🔁 Repeating Mode")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.top, 5)
                        }
                        
                        Button(action: {
                            viewModel.cancelTimer()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "stop.circle.fill")
                                Text(viewModel.timerMode == 1 ? "Stop Repeating" : "Stop Timer")
                            }
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.vertical, 40)
                } else {
                    // Timer Setup
                    VStack(spacing: 25) {
                        // Mode Selection
                        Picker("Mode", selection: $viewModel.timerMode) {
                            Text("Single Timer").tag(0)
                            Text("Repeat Mode").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        // Category Selection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Fart Type:")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Picker("Category", selection: $viewModel.selectedCategory) {
                                Text("💨 Short").tag(0)
                                Text("💨💨 Medium").tag(1)
                                Text("💨💨💨 Long").tag(2)
                                Text("🎲 Random").tag(3)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .padding(.horizontal)
                        
                        // Interval Selection
                        VStack(alignment: .leading, spacing: 10) {
                            Text(viewModel.timerMode == 0 ? "Delay:" : "Repeat Every:")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Picker("Interval", selection: $viewModel.selectedInterval) {
                                ForEach(0..<viewModel.intervals.count, id: \.self) { index in
                                    Text(viewModel.intervals[index].name).tag(index)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 150)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        // Start Button
                        Button(action: {
                            // Prevent rapid taps
                            guard !viewModel.isTimerRunning else { return }
                            viewModel.startTimer()
                        }) {
                            HStack {
                                Image(systemName: "timer")
                                Text(viewModel.timerMode == 0 ? "Start Timer" : "Start Repeating")
                            }
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.red]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                        }
                        .disabled(viewModel.isTimerRunning)
                        .opacity(viewModel.isTimerRunning ? 0.5 : 1.0)
                        .padding(.horizontal, 30)
                    }
                }
                
                Spacer()
                
                // Info Text
                if !viewModel.isTimerRunning {
                    Text("💡 Tip: Use repeat mode to prank someone with periodic farts!")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            viewModel.configure(with: audioManager)
            viewModel.syncTimerState()
        }
        // Removed onDisappear - let user control timer manually
        // Timer will persist even when switching tabs, allowing user to stop it
    }
}

@available(iOS 13.0, *)
class TimerViewModel: ObservableObject {
    @Published var timerMode: Int = 0 // 0 = single, 1 = repeat
    @Published var selectedCategory: Int = 3 // 0=short, 1=medium, 2=long, 3=random
    @Published var selectedInterval: Int = 2 // Default to 15 seconds
    @Published var isTimerRunning: Bool = false
    @Published var timeDisplay: String = "0:00"
    
    private var fartTimer: FartTimer?
    private var audioManager: AudioManager?
    private var isConfigured = false
    
    let intervals = [
        (name: "5 seconds", seconds: 5),
        (name: "10 seconds", seconds: 10),
        (name: "15 seconds", seconds: 15),
        (name: "30 seconds", seconds: 30),
        (name: "1 minute", seconds: 60),
        (name: "2 minutes", seconds: 120),
        (name: "5 minutes", seconds: 300)
    ]
    
    func configure(with audioManager: AudioManager) {
        // Only configure once to prevent recreating the timer
        guard !isConfigured else {
            // Update audio manager reference if it changed
            self.audioManager = audioManager
            // Reconnect delegate if timer exists
            if let timer = fartTimer {
                timer.delegate = self
            }
            return
        }
        
        self.audioManager = audioManager
        self.fartTimer = FartTimer(audioManager: audioManager)
        self.fartTimer?.delegate = self
        self.isConfigured = true
        print("⏰ TimerViewModel configured")
    }
    
    func startTimer() {
        // Prevent multiple starts
        guard !isTimerRunning else {
            print("⚠️ Timer already running, ignoring start request")
            return
        }
        
        guard let fartTimer = fartTimer else {
            print("❌ FartTimer not initialized")
            return
        }
        
        let category: FartCategory
        switch selectedCategory {
        case 0: category = .short
        case 1: category = .medium
        case 2: category = .long
        default: category = .random
        }
        
        let interval = intervals[selectedInterval].seconds
        
        if timerMode == 0 {
            fartTimer.startSingleTimer(delay: interval, category: category)
        } else {
            fartTimer.startRepeatingTimer(interval: interval, category: category)
        }
        
        isTimerRunning = true
        print("✅ Timer started successfully")
    }
    
    func cancelTimer() {
        guard isTimerRunning else { return }
        
        fartTimer?.stopTimer()
        isTimerRunning = false
        timeDisplay = "0:00"
        print("🛑 Timer cancelled")
    }
    
    // Sync state with timer if it's still running
    func syncTimerState() {
        if let timer = fartTimer, timer.isRunning() {
            isTimerRunning = true
            timeDisplay = FartTimer.formatTime(seconds: timer.getRemainingSeconds())
        }
    }
}

@available(iOS 13.0, *)
extension TimerViewModel: FartTimerDelegate {
    func timerDidTick(secondsRemaining: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.timeDisplay = FartTimer.formatTime(seconds: secondsRemaining)
        }
    }
    
    func timerWillPlayFart() {
        // Could add visual/haptic feedback here
    }
    
    func timerDidComplete() {
        DispatchQueue.main.async { [weak self] in
            self?.isTimerRunning = false
            self?.timeDisplay = "0:00"
        }
    }
    
    func timerDidCancel() {
        DispatchQueue.main.async { [weak self] in
            self?.isTimerRunning = false
            self?.timeDisplay = "0:00"
        }
    }
}

@available(iOS 13.0, *)
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
