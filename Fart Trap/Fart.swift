//
//  Fart.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 4/16/15.
//  Copyright (c) 2015 BangBangStudios. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AudioToolbox

protocol FartType{
    func setFartLabel(_ name: String)
}

class Fart{
    var audioPlayer: AVAudioPlayer! = AVAudioPlayer()
    var fartSound: String! = String()
    var fartGenerator = FartGenerator()
    var delegate: FartType?
    
    func shortFartButtonPressed(){
        let randomFart = fartGenerator.randomShortFartChoser()
        fartCreator(randomFart)
        delegate?.setFartLabel(randomFart)
        
    }
    func mediumFartButtonPressed(){
        let randomFart = fartGenerator.randomMediumFartChoser()
        fartCreator(randomFart)
        delegate?.setFartLabel(randomFart)
    }
    func longFartButtonPressed(){
        let randomFart = fartGenerator.randomLongFartChoser()
        fartCreator(randomFart)
        delegate?.setFartLabel(randomFart)
    }
    func playRandomFartSound() {
        let randomFart = fartGenerator.randomFartChoser()
        fartCreator(randomFart)
        delegate?.setFartLabel(randomFart)
    }
//    func fartCreator(soundName: String, fileType: String) -> SystemSoundID {
//        var  soundID: SystemSoundID = 0
//        let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), soundName, fileType, nil)
//        AudioServicesCreateSystemSoundID(soundURL, &soundID)
//        
//        return soundID
//    }
    
    func fartCreator(_ soundName: String){
        playFart(soundName)
        delegate?.setFartLabel(soundName)
    }
    
    func playFart(_ name: String){
        let alertSound: URL? = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!)
        
        if let alertSound = alertSound{
            do{
                
                audioPlayer = try AVAudioPlayer(contentsOf: alertSound)
                if audioPlayer.isPlaying == true{
                    audioPlayer.stop()
                }
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 1.0
                audioPlayer.play()
            }catch{
                print("error with playing audio")
            }
        }else{
            print("File doesn't exist")
        }
    }
    
}
