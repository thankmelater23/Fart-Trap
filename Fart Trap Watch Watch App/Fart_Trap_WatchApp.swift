//
//  Fart_Trap_WatchApp.swift
//  Fart Trap Watch Watch App
//
//  Created by Andre Villanueva on 12/28/25.
//

import SwiftUI

@main
struct Fart_Trap_Watch_Watch_AppApp: App {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(connectivityManager)
        }
    }
}
