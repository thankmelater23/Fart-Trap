//
//  FartModels.swift
//  Fart Trap Watch
//
//  Created by Andre Villanueva on 12/28/24.
//  Copyright © 2024 Bang Bang Studios. All rights reserved.
//

import Foundation

// MARK: - Fart Category

enum FartCategory: String, Codable, CaseIterable {
    case short
    case medium
    case long
    case random
    
    var displayName: String {
        switch self {
        case .short: return "💨 Short Fart"
        case .medium: return "💨💨 Medium Fart"
        case .long: return "💨💨💨 Long Fart"
        case .random: return "🎲 Random Fart"
        }
    }
    
    var compactName: String {
        switch self {
        case .short: return "Short"
        case .medium: return "Medium"
        case .long: return "Long"
        case .random: return "Random"
        }
    }
}

// MARK: - Watch Message Protocol

struct WatchMessage: Codable {
    let action: WatchAction
    let category: FartCategory?
    let timestamp: Date
    
    enum WatchAction: String, Codable {
        case playFart
        case getStatus
        case statusUpdate
    }
    
    init(action: WatchAction, category: FartCategory? = nil) {
        self.action = action
        self.category = category
        self.timestamp = Date()
    }
    
    // Convert to dictionary for WatchConnectivity
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "action": action.rawValue,
            "timestamp": timestamp.timeIntervalSince1970
        ]
        if let category = category {
            dict["category"] = category.rawValue
        }
        return dict
    }
    
    // Create from dictionary
    static func fromDictionary(_ dict: [String: Any]) -> WatchMessage? {
        guard let actionString = dict["action"] as? String,
              let action = WatchAction(rawValue: actionString) else {
            return nil
        }
        
        var category: FartCategory?
        if let categoryString = dict["category"] as? String {
            category = FartCategory(rawValue: categoryString)
        }
        
        // Create message - timestamp will be set to current time via init
        let message = WatchMessage(action: action, category: category)
        return message
    }
}

