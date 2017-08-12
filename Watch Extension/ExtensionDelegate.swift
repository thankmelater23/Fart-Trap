//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Andre Villanueva on 5/12/16.
//  Copyright © 2016 Bang Bang Studios. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    open func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }

    let session: WCSession!
    let fartGenerator = FartGenerator()
    
    override init() {
        if(WCSession.isSupported()){
            session = WCSession.default
        }else{
            session = nil
        }
        super.init()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(WCSession.isSupported()){
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func sendMessage(_ message: [String: String]){
        session.sendMessage(message, replyHandler: {response  -> Void in
            print(response)}, errorHandler: {error -> Void in
                print(error)})
//        session.sendMessage(message, replyHandler: nil, errorHandler: { (error) -> Void in
//            print("sendMessage failed with error \(error)")
//        })
    }
    
    
    
    @IBAction func allFart() {
        let message = [FartKey: fartGenerator.randomFartChoser()]
        self.sendMessage(message)
    }
    @IBAction func shortFart() {
        let message = [FartKey: fartGenerator.randomShortFartChoser()]
        self.sendMessage(message)
        
    }
    @IBAction func mediumFart() {
        let message = [FartKey: fartGenerator.randomMediumFartChoser()]
        self.sendMessage(message)
    }
    @IBAction func longFart() {
        let message = [FartKey: fartGenerator.randomLongFartChoser()]
        self.sendMessage(message)
    }
}
