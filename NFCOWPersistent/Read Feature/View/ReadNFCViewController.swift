//
//  ReadNFCViewController.swift
//  NFCOWPersistent
//
//  Created by Beatrix Kang on 09/03/2023.
//

import UIKit
import CoreNFC
import CoreData


class ReadNFCViewController: UIViewController {
  
    var readNFCView = ReadNFCViewModel()
    
    var timeString = ""
    let nfcReader = NFCReader()
    
    let projectView = ReadNFCViewModel()
    
    @IBOutlet var projectLabel: UILabel!
    @IBOutlet var timerView: UILabel!
    @IBOutlet var endTaskBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        nfcReader.delegate = self
        TimerManager.shared.delegate = self
        projectLabel.text = projectView.projectString
        
        //no timer in core data to begin with
        if projectView.timerNotCreated {
            nfcReader.begin()
        }
        else {
            let status = projectView.timerRunning
            switch status{
            case true:
                projectView.assignProjectFromCore()
                projectLabel.text = projectView.projectString
                projectView.startTimerAfterClose()
            case false:
                projectView.assignProjectFromCore()
                projectLabel.text = projectView.projectString
                projectView.assignPausedTimeFromCore()
                timerView.text = projectView.timeString
            }
            
            
        }
        
        
    }
    
    
    
    
    @IBAction func scanButton(_ sender: UIButton) {
            nfcReader.begin()
    }
    
    
    //prepare for segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "readToCompleteSegue" {
            let destinationVc = segue.destination as! CompletionViewController
            destinationVc.project = projectView.projectString
            destinationVc.totalTimeString = projectView.totalTimeString
        }
    }
    
    
    
    
    
  
}

extension ReadNFCViewController : TimerManagerDelegate{
    func timerManager(_ timerManager: TimerManager, didUpdateElapsedTime elapsedTime: TimeInterval) {
        //timeString = TimerManager.shared.timeConversion(elapsedTime: elapsedTime)
        timerView.text = projectView.timerUpdated(elapsedTime: elapsedTime)
        //print (timeString)
    }
    
    
}

extension ReadNFCViewController: NFCReaderDelegate {
   
    
    func didReceive(payload: String) {
        
        projectView.jsonObject(payload: payload)
      
        
        
        if (projectView.jsonDataValid){
            if projectView.timerNotCreated{
                projectLabel.text = projectView.projectString
                projectView.startTimerFirstTime()
            } else if projectView.sameCardScanned{
                let status = projectView.timerRunning
                switch status{
                case true:
                    self.present(PopUp().timerRunning(), animated: true, completion: nil)
                case false:
                    self.present(PopUp().timerPaused(),animated:true, completion:nil)
                }
                
            }else{
                self.present(PopUp().wrongCard(),animated:true, completion:nil)
            }
        } else {
            let alert = PopUp().emptyCard()
            alert.addAction(UIAlertAction(title: "Write Data", style: UIAlertAction.Style.default, handler: {_ in self.performSegue(withIdentifier: "showWriteSegue", sender: self)}))
            self.present(alert, animated: true)
        }
        
    }
    
    
      
    
    
   
}
