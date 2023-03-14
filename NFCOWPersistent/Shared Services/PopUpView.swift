//
//  PopUpView.swift
//  NFCOWPersistent
//
//  Created by Beatrix Kang on 09/03/2023.
//

import Foundation
import UIKit

struct PopUp{
    
    
    func timerRunning()->UIAlertController{
        let alert = UIAlertController(title: "Timer is Running", message: "Do you wish to continue?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(timerPauseAction())
        alert.addAction(timerStopAction())
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    func timerPaused()->UIAlertController{
        let alert = UIAlertController(title: "Timer is Paused", message: "Do you wish to continue?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(timerResumeAction())
        alert.addAction(timerStopAction())
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    func wrongCard()->UIAlertController{
        let alert = UIAlertController(title: "NFC Card is Invalid", message: "Please Use Correct Card", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    
    //actions
    func timerPauseAction() -> UIAlertAction {
        let pauseAction = UIAlertAction(title: "Pause", style: UIAlertAction.Style.default, handler: {
            (action) in
            TimerManager.shared.pause()
        }
        )
        return pauseAction
        
    }
    
    func timerResumeAction() -> UIAlertAction {
        let resumeAction = UIAlertAction(title: "Resume", style: UIAlertAction.Style.default, handler: {
            (action) in
            TimerManager.shared.resume()
        }
        )
        return resumeAction
    }
    
    func timerStopAction() -> UIAlertAction{
        let stopAction = UIAlertAction(title: "Stop", style: UIAlertAction.Style.default, handler: {
            (action) in
            //performSegue(withIdentifier: "readToCompleteSegue", sender: nil)
            TimerManager.shared.stop()
        }
        )
        return stopAction
    }
    
  
    
}
