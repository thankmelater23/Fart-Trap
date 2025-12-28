//
//  ContentView.swift
//  Fart Trap Watch Watch App
//
//  Created by Andre Villanueva on 12/28/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    @State private var lastPlayedCategory: FartCategory?
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main Farts View
            WatchFartsView(lastPlayedCategory: $lastPlayedCategory)
                .environmentObject(connectivityManager)
                .tag(0)
            
            // All Sounds List
            WatchSoundsListView()
                .environmentObject(connectivityManager)
                .tag(1)
            
            // Timer View
            WatchTimerView()
                .environmentObject(connectivityManager)
                .tag(2)
            
            // Info/Status View
            WatchInfoView()
                .environmentObject(connectivityManager)
                .tag(3)
        }
        .tabViewStyle(.page)
    }
}

// MARK: - Main Farts View

struct WatchFartsView: View {
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    @Binding var lastPlayedCategory: FartCategory?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // Header
                VStack(spacing: 6) {
                    Text("💨")
                        .font(.system(size: 36))
                    
                    Text("Fart Trap")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Connection Status
                    HStack(spacing: 6) {
                        Circle()
                            .fill(connectivityManager.isPhoneReachable ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        
                        Text(connectivityManager.isPhoneReachable ? "Connected" : "Not Connected")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(connectivityManager.isPhoneReachable ? .green : .red)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.3))
                    )
                }
                .padding(.top, 6)
                .padding(.bottom, 6)
                
                // Fart Buttons
                VStack(spacing: 8) {
                    WatchFartButton(
                        category: .short,
                        icon: "💨",
                        color: .orange,
                        connectivityManager: connectivityManager,
                        lastPlayed: $lastPlayedCategory
                    )
                    
                    WatchFartButton(
                        category: .medium,
                        icon: "💨💨",
                        color: .orange,
                        connectivityManager: connectivityManager,
                        lastPlayed: $lastPlayedCategory
                    )
                    
                    WatchFartButton(
                        category: .long,
                        icon: "💨💨💨",
                        color: .orange,
                        connectivityManager: connectivityManager,
                        lastPlayed: $lastPlayedCategory
                    )
                    
                    WatchFartButton(
                        category: .random,
                        icon: "🎲",
                        color: .green,
                        connectivityManager: connectivityManager,
                        lastPlayed: $lastPlayedCategory
                    )
                    
                    // Replay Last Button
                    if let lastCategory = lastPlayedCategory {
                        WatchFartButton(
                            category: lastCategory,
                            icon: "🔁",
                            color: .blue,
                            connectivityManager: connectivityManager,
                            lastPlayed: $lastPlayedCategory,
                            isReplay: true
                        )
                    }
                }
                .padding(.horizontal, 6)
                .padding(.bottom, 8)
            }
        }
    }
}

// MARK: - All Sounds List View

struct WatchSoundsListView: View {
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    @State private var allSounds: [String] = []
    @State private var searchText = ""
    
    var filteredSounds: [String] {
        if searchText.isEmpty {
            return allSounds
        }
        return allSounds.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                // Header
                Text("All Sounds")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                
                // Sounds List
                ForEach(filteredSounds.prefix(20), id: \.self) { soundName in
                    Button(action: {
                        // Send command to play specific sound
                        // Note: This requires adding a new message type for specific sounds
                        // For now, send as random category
                        connectivityManager.sendFartCommand(category: .random)
                    }) {
                        HStack {
                            Text(soundName)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.orange.opacity(0.6))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 6)
        }
        .onAppear {
            loadSounds()
        }
    }
    
    private func loadSounds() {
        // All fart sounds from Resources folder
        allSounds = [
            "Drive By Farting",
            "Fart Reverberating Bathroom",
            "Fart Short Ripper",
            "Fart Strain",
            "Girl Fart",
            "Girls Farting",
            "Long Fart",
            "Motor Bike Fart",
            "Oopsy Daisy Fart",
            "Person Farting",
            "Quick An Small Fart",
            "Quick Fart",
            "Rigid Fart",
            "Sharp Fart",
            "Silly Farts Joe",
            "Squish Fart",
            "Toilet_Flushing-Kevan",
            "Trumpet Fart",
            "Uh Oh Fart",
            "Uuuuuu-Paula",
            "Wet Fart",
            "Wet Fart Squish",
            "Windy Fart"
        ].sorted()
    }
}

// MARK: - Timer View

struct WatchTimerView: View {
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    @StateObject private var viewModel = WatchTimerViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Header
                Text("⏰ Timer")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                
                if viewModel.isTimerRunning {
                    // Timer Running
                    VStack(spacing: 10) {
                        Text("Next fart:")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(viewModel.timeDisplay)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .monospacedDigit()
                        
                        if viewModel.timerMode == 1 {
                            Text("🔁 Repeating")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Button(action: {
                            viewModel.cancelTimer()
                        }) {
                            Text("Stop")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 20)
                } else {
                    // Timer Setup
                    VStack(spacing: 10) {
                        // Mode - Use buttons for watchOS
                        VStack(spacing: 6) {
                            Text("Mode:")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 8) {
                                Button(action: { viewModel.timerMode = 0 }) {
                                    Text("Single")
                                        .font(.system(size: 12, weight: viewModel.timerMode == 0 ? .bold : .regular))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(viewModel.timerMode == 0 ? Color.green : Color.gray.opacity(0.5))
                                        .cornerRadius(6)
                                }
                                
                                Button(action: { viewModel.timerMode = 1 }) {
                                    Text("Repeat")
                                        .font(.system(size: 12, weight: viewModel.timerMode == 1 ? .bold : .regular))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(viewModel.timerMode == 1 ? Color.green : Color.gray.opacity(0.5))
                                        .cornerRadius(6)
                                }
                            }
                        }
                        
                        // Category
                        Picker("Category", selection: $viewModel.selectedCategory) {
                            Text("Short").tag(0)
                            Text("Medium").tag(1)
                            Text("Long").tag(2)
                            Text("Random").tag(3)
                        }
                        #if os(watchOS)
                        .pickerStyle(.wheel)
                        #else
                        .pickerStyle(.menu)
                        #endif
                        .frame(height: 60)
                        
                        // Interval
                        Picker("Interval", selection: $viewModel.selectedInterval) {
                            ForEach(0..<viewModel.intervals.count, id: \.self) { index in
                                Text(viewModel.intervals[index].name).tag(index)
                            }
                        }
                        #if os(watchOS)
                        .pickerStyle(.wheel)
                        #else
                        .pickerStyle(.menu)
                        #endif
                        .frame(height: 60)
                        
                        // Start Button
                        Button(action: {
                            viewModel.startTimer(connectivityManager: connectivityManager)
                        }) {
                            Text(viewModel.timerMode == 0 ? "Start" : "Start Repeat")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 6)
                }
            }
        }
        .onAppear {
            viewModel.syncTimerState()
        }
    }
}

// MARK: - Watch Timer ViewModel

class WatchTimerViewModel: ObservableObject {
    @Published var timerMode: Int = 0 // 0 = single, 1 = repeat
    @Published var selectedCategory: Int = 3 // 0=short, 1=medium, 2=long, 3=random
    @Published var selectedInterval: Int = 2 // Default to 15 seconds
    @Published var isTimerRunning: Bool = false
    @Published var timeDisplay: String = "0:00"
    
    private var timer: Timer?
    private var countdown: Int = 0
    private var currentCategory: FartCategory = .random
    private var currentInterval: Int = 0
    
    let intervals = [
        (name: "5s", seconds: 5),
        (name: "10s", seconds: 10),
        (name: "15s", seconds: 15),
        (name: "30s", seconds: 30),
        (name: "1m", seconds: 60),
        (name: "2m", seconds: 120),
        (name: "5m", seconds: 300)
    ]
    
    func startTimer(connectivityManager: WatchConnectivityManager) {
        // Prevent multiple starts
        guard !isTimerRunning else { return }
        
        let category: FartCategory
        switch selectedCategory {
        case 0: category = .short
        case 1: category = .medium
        case 2: category = .long
        default: category = .random
        }
        
        let interval = intervals[selectedInterval].seconds
        currentCategory = category
        currentInterval = interval
        countdown = interval
        isTimerRunning = true
        timeDisplay = formatTime(seconds: countdown)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.countdown -= 1
            self.timeDisplay = self.formatTime(seconds: self.countdown)
            
            if self.countdown <= 0 {
                // Send command to iPhone
                connectivityManager.sendFartCommand(category: self.currentCategory)
                
                if self.timerMode == 0 {
                    // Single timer - stop
                    self.cancelTimer()
                } else {
                    // Repeat - reset
                    self.countdown = self.currentInterval
                    self.timeDisplay = self.formatTime(seconds: self.countdown)
                }
            }
        }
        
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        timeDisplay = "0:00"
        countdown = 0
    }
    
    func syncTimerState() {
        // If timer is running, update display from countdown
        // This ensures the view shows correct state when reappearing
        if isTimerRunning && countdown > 0 {
            timeDisplay = formatTime(seconds: countdown)
        } else if isTimerRunning && countdown <= 0 {
            // Timer might have fired while view was away, check if still running
            if timer == nil {
                isTimerRunning = false
                timeDisplay = "0:00"
            }
        }
    }
    
    private func formatTime(seconds: Int) -> String {
        if seconds >= 60 {
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            return String(format: "%d:%02d", minutes, remainingSeconds)
        } else {
            return "\(seconds)s"
        }
    }
}

// MARK: - Info View

struct WatchInfoView: View {
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Header
                Text("ℹ️ Info")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                
                // Connection Status
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(connectivityManager.isPhoneReachable ? Color.green : Color.red)
                            .frame(width: 10, height: 10)
                        
                        Text(connectivityManager.isPhoneReachable ? "iPhone Connected" : "iPhone Not Connected")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    if let lastMessage = connectivityManager.lastMessageSent {
                        Text("Last sent: \(formatTime(lastMessage))")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    if let error = connectivityManager.lastError {
                        Text("Error: \(error)")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.3))
                )
                
                // Instructions
                VStack(alignment: .leading, spacing: 6) {
                    Text("How to Use:")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("1. Tap any fart button to play")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("2. Use Timer for delayed farts")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("3. Keep iPhone app open")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.8))
        }
        .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.3))
                )
                
                // Credits
                Text("Bang Bang Studios")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, 8)
            }
            .padding(.horizontal, 6)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Watch Fart Button

struct WatchFartButton: View {
    let category: FartCategory
    let icon: String
    let color: Color
    let connectivityManager: WatchConnectivityManager
    @Binding var lastPlayed: FartCategory?
    var isReplay: Bool = false
    
    @State private var isPressed = false
    
    var buttonTitle: String {
        if isReplay {
            return "Replay Last"
        }
        return category.compactName
    }
    
    var body: some View {
        Button(action: {
            triggerFart()
        }) {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: isReplay ? 16 : 18))
                
                Text(buttonTitle)
                    .font(.system(size: isReplay ? 13 : 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.vertical, isReplay ? 8 : 10)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .opacity(isPressed ? 0.7 : 1.0)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func triggerFart() {
        // Visual feedback
        withAnimation(.easeInOut(duration: 0.1)) {
            isPressed = true
        }
        
        // Send message to iPhone
        connectivityManager.sendFartCommand(category: category)
        
        // Track last played (unless it's already a replay)
        if !isReplay {
            lastPlayed = category
        }
        
        // Reset visual state
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                isPressed = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WatchConnectivityManager.shared)
}
