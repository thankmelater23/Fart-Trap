//
//  WatchConnectivityManager.swift
//  Fart Trap Watch
//
//  Created by Andre Villanueva on 12/28/24.
//  Copyright © 2024 Bang Bang Studios. All rights reserved.
//

import Foundation
import Combine
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isPhoneConnected: Bool = false
    @Published var isPhoneReachable: Bool = false
    @Published var lastMessageSent: Date?
    @Published var lastError: String?
    
    // MARK: - Properties
    
    static let shared = WatchConnectivityManager()
    
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
    
    func sendFartCommand(category: FartCategory) {
        guard WCSession.default.isReachable else {
            DispatchQueue.main.async { [weak self] in
                self?.lastError = "iPhone not reachable"
            }
            return
        }
        
        let message = WatchMessage(action: .playFart, category: category)
        
        WCSession.default.sendMessage(message.toDictionary(), replyHandler: { reply in
            DispatchQueue.main.async { [weak self] in
                self?.lastMessageSent = Date()
                self?.lastError = nil
            }
        }, errorHandler: { error in
            DispatchQueue.main.async { [weak self] in
                self?.lastError = error.localizedDescription
            }
        })
    }
}

// MARK: - WCSessionDelegate

extension WatchConnectivityManager: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.isPhoneConnected = activationState == .activated
            self?.isPhoneReachable = session.isReachable
            
            if let error = error {
                self?.lastError = error.localizedDescription
            }
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async { [weak self] in
            self?.isPhoneReachable = session.isReachable
        }
    }
    
    // MARK: - Message Handling
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Handle any messages from iPhone if needed
    }
}

