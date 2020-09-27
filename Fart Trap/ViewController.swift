
//
//  MulipleOptionsViewController.swift
//  Fart Trap
//
//  Created by Andre Villanueva on 4/17/15.
//  Copyright (c) 2015 BangBangStudios. All rights reserved.
//

import UIKit
import AVFoundation
//import AudioToolbox
//import WatchKitzx
import WatchConnectivity


class ViewController: UIViewController, FartType, WCSessionDelegate {
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    open func sessionDidDeactivate(_ session: WCSession) {
        //
    }

    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    open func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }

    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    open func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }

    var session: WCSession!
    let fartGenerator = FartGenerator()
    var audioPlayer: AVAudioPlayer!
    var fartSound: SystemSoundID!
    let fart = Fart()
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fart.delegate = self
        
        if(WCSession.isSupported()){
            session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }else{
            session = nil
        }
        
        self.tipAlert()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        
        self.session = WCSession.default
        
        super.init(coder: aDecoder)
    }
    
    func setFartLabel(_ name: String) {
        label.text = name
    }
    func labelFartType(_ string: String){
        label.text = string
    }
    
    @IBAction func shortFartButtonPressed(_ sender: UIButton) {
        fart.shortFartButtonPressed()
    }
    @IBAction func mediumFartButtonPressed(_ sender: UIButton) {
        fart.mediumFartButtonPressed()
    }
    @IBAction func longFartButtonPressed(_ sender: UIButton) {
        fart.longFartButtonPressed()
    }
    @IBAction func allFartsButtonPressed(_ sender: UIButton){
        fart.playRandomFartSound()
    }
    @IBAction func giveTip(_ sender: UIButton){
        self.tipAlert()
        
    }
    
    func tipAlert(){
        let alert = UIAlertController(title: "Attention", message: "Please keep app in the foreground with the ringer on to enjoy fart trap", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController{//WCSessionDelegate
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let fartString = message[FartKey]! as! String
        fart.fartCreator(fartString)
    }
}

