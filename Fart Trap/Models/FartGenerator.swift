//
//  FartGenerator.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 7/29/16.
//  Copyright © 2016 Bang Bang Studios. All rights reserved.
//

import Foundation

let FartKey = "FartString"

struct FartGenerator {
    
    // MARK: - Fart Collections
    
    private let allFarts = [
        "Squish Fart",
        "Sharp Fart",
        "Fart Short Ripper",
        "Quick Fart",
        "Drive By Farting",
        "Person Farting",
        "Uuuuuu-Paula",
        "Fart Strain",
        "Trumpet Fart",
        "Uh Oh Fart",
        "Wet Fart Squish",
        "Oopsy Daisy Fart",
        "Motor Bike Fart",
        "Silly Farts Joe",
        "Long Fart"
    ]
    
    private let shortFarts = [
        "Squish Fart",
        "Sharp Fart",
        "Fart Short Ripper",
        "Quick Fart"
    ]
    
    private let mediumFarts = [
        "Drive By Farting",
        "Person Farting",
        "Uuuuuu-Paula",
        "Fart Strain",
        "Trumpet Fart",
        "Wet Fart Squish"
    ]
    
    private let longFarts = [
        "Person Farting",
        "Oopsy Daisy Fart",
        "Long Fart",
        "Motor Bike Fart",
        "Silly Farts Joe",
        "Squish Fart"
    ]
    
    // MARK: - Random Choosers
    
    func randomFartChoser() -> String {
        let chosen = allFarts.randomElement() ?? "Quick Fart"
        print("🎲 Random fart selected: \(chosen)")
        return chosen
    }

    func randomShortFartChoser() -> String {
        let chosen = shortFarts.randomElement() ?? "Quick Fart"
        print("💨 Short fart selected: \(chosen)")
        return chosen
    }

    func randomMediumFartChoser() -> String {
        let chosen = mediumFarts.randomElement() ?? "Drive By Farting"
        print("💨💨 Medium fart selected: \(chosen)")
        return chosen
    }

    func randomLongFartChoser() -> String {
        let chosen = longFarts.randomElement() ?? "Long Fart"
        print("💨💨💨 Long fart selected: \(chosen)")
        return chosen
    }
    
    // MARK: - Get All Fart Sounds
    
    func getAllFartSounds() -> [String] {
        // Get all unique fart sounds from all categories
        var allUniqueFarts = Set<String>()
        allUniqueFarts.formUnion(allFarts)
        allUniqueFarts.formUnion(shortFarts)
        allUniqueFarts.formUnion(mediumFarts)
        allUniqueFarts.formUnion(longFarts)
        
        // Add all sounds from Resources folder
        let allResourceSounds = [
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
        ]
        
        allUniqueFarts.formUnion(allResourceSounds)
        
        // Return sorted list
        return Array(allUniqueFarts).sorted()
    }
}
