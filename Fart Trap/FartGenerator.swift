//
//  FartGenerator.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 7/29/16.
//  Copyright © 2016 Bang Bang Studios. All rights reserved.
//

import Foundation

let FartKey = "FartString"

struct FartGenerator{
    
    func randomFartChoser() -> String {
        var chosenFart: String!
        let randomNumber = Int(arc4random_uniform(18))
        
        switch randomNumber {
            
        case 0:
            chosenFart = "Squish Fart"
        case 1:
            chosenFart = "Sharp Fart"
        case 2:
            chosenFart = "Fart Short Ripper"
        case 3:
            chosenFart = "Quick Fart"
        case 4:
            chosenFart = "Drive By Farting"
        case 5:
            chosenFart = "Person Farting"
        case 6:
            chosenFart = "Uuuuuu-Paula"
        case 7:
            chosenFart = "Fart Strain"
        case 8:
            chosenFart = "Trumpet Fart"
        case 9:
            chosenFart = "Uh Oh Fart"
        case 10:
            chosenFart = "Wet Fart Squish"
        case 11:
            chosenFart = "Person Farting"
        case 12:
            chosenFart = "Oopsy Daisy Fart"
        case 13:
            chosenFart = "Motor Bike Fart"
        case 14:
            chosenFart = "Trumpet Fart"
        case 15:
            chosenFart = "Silly Farts Joe"
        case 16:
            chosenFart = "Squish Fart"
        case 17:
            chosenFart = "Long Fart"
            
        default:
            break
        }
        
        print("#: \(randomNumber) Name: \(chosenFart)")
        return chosenFart
    }
    
    func randomShortFartChoser() -> String {
        var chosenFart: String!
        let randomNumber = Int(arc4random_uniform(4))
        
        switch randomNumber {
        case 0:
            chosenFart = "Squish Fart"
        case 1:
            chosenFart = "Sharp Fart"
        case 2:
            chosenFart = "Fart Short Ripper"
        case 3:
            chosenFart = "Quick Fart"
            
        default:
            break
        }
        
        print("#: \(randomNumber) Name: \(chosenFart)")
        return chosenFart
    }
    
    func randomMediumFartChoser() -> String {
        var chosenFart: String!
        let randomNumber = Int(arc4random_uniform(6))
        
        switch randomNumber {
        case 0:
            chosenFart = "Drive By Farting"
        case 1:
            chosenFart = "Person Farting"
        case 2:
        chosenFart = "Uuuuuu-Paula"
        case 3:
            chosenFart = "Fart Strain"
        case 4:
            chosenFart = "Trumpet Fart"
        case 5:
            chosenFart = "Wet Fart Squish"
        
        default:
            break
        }
        
        print("#: \(randomNumber) Name: \(chosenFart)")
        return chosenFart
    }
    
    func randomLongFartChoser() -> String {
        var chosenFart: String!
        let randomNumber = Int(arc4random_uniform(6))
        
        switch randomNumber {
        case 0:
            chosenFart = "Person Farting"
        case 1:
            chosenFart = "Oopsy Daisy Fart"
        case 2:
            chosenFart = "Long Fart"
        case 3:
            chosenFart = "Motor Bike Fart"
        case 4:
            chosenFart = "Silly Farts Joe"
        case 5:
            chosenFart = "Squish Fart"
            
        default:
            break
        }
        
        print("#: \(randomNumber) Name: \(chosenFart)")
        return chosenFart
    }
}
