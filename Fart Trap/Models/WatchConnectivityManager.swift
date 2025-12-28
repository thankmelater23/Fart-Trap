//
//  WatchConnectivityManager.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 12/28/24.
//  Copyright © 2024 Bang Bang Studios. All rights reserved.
//

import Foundation
import Combine
import WatchConnectivity

@available(iOS 13.0, *)
class WatchConnectivityManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isWatchConnected: Bool = false
    @Published var isWatchReachable: Bool = false
    @Published var lastMessageReceived: Date?
    
    // MARK: - Properties
    
    static let shared = WatchConnectivityManager()
    private var audioManager: AudioManager?
    
    // MARK: - Initialization
    
    override private init() {
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // MARK: - Public Methods
    
    func setAudioManager(_ manager: AudioManager) {
        self.audioManager = manager
    }
    
    func sendMessage(_ message: WatchMessage, replyHandler: (([String: Any]) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            errorHandler?(NSError(domain: "WatchConnectivity", code: -1, userInfo: [NSLocalizedDescriptionKey: "Watch not reachable"]))
            return
        }
        
        WCSession.default.sendMessage(message.toDictionary(), replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    func updateApplicationContext(_ context: [String: Any]) {
        do {
            try WCSession.default.updateApplicationContext(context)
        } catch {
            print("Failed to update application context: \(error.localizedDescription)")
        }
    }
}

// MARK: - WCSessionDelegate

@available(iOS 13.0, *)
extension WatchConnectivityManager: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.isWatchConnected = activationState == .activated
            if let error = error {
                print("❌ WCSession activation failed: \(error.localizedDescription)")
            } else {
                print("✅ WCSession activated (state: \(activationState.rawValue))")
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("⚠️ WCSession became inactive")
        DispatchQueue.main.async { [weak self] in
            self?.isWatchConnected = false
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("⚠️ WCSession deactivated - reactivating")
        DispatchQueue.main.async { [weak self] in
            self?.isWatchConnected = false
        }
        session.activate()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("📡 Watch reachability: \(session.isReachable ? "Connected" : "Disconnected")")
        DispatchQueue.main.async { [weak self] in
            self?.isWatchReachable = session.isReachable
        }
    }
    
    // MARK: - Message Handling
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("📨 Received message from Watch: \(message)")
        handleWatchMessage(message)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("📨 Received message from Watch (with reply): \(message)")
        handleWatchMessage(message)
        
        // Send reply
        let reply: [String: Any] = [
            "status": "received",
            "timestamp": Date().timeIntervalSince1970
        ]
        replyHandler(reply)
    }
    
    private func handleWatchMessage(_ messageDict: [String: Any]) {
        guard let watchMessage = WatchMessage.fromDictionary(messageDict) else {
            print("⚠️ Failed to parse watch message")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.lastMessageReceived = Date()
        }
        
        switch watchMessage.action {
        case .playFart:
            if let category = watchMessage.category {
                print("⌚→📱 Watch triggered fart: \(category.rawValue)")
                // Play on main thread to ensure audio session is active
                DispatchQueue.main.async { [weak self] in
                    self?.audioManager?.playFart(category: category)
                }
            }
            
        case .getStatus:
            print("📊 Watch requested status")
            break
            
        case .statusUpdate:
            print("ℹ️ Received status update from Watch")
            break
        }
    }
}

