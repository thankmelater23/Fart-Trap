//
//  Fart_TrapApp.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 12/28/25.
//

import SwiftUI

@main
struct Fart_TrapApp: App {
    @StateObject private var audioManager = AudioManager()
    @StateObject private var watchManager = WatchConnectivityManager.shared
    
    init() {
        // Configure WatchConnectivity to use the audio manager
        // This will be set after StateObject initialization
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioManager)
                .environmentObject(watchManager)
                .onAppear {
                    watchManager.setAudioManager(audioManager)
                }
        }
    }
}
