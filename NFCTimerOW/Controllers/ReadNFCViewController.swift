//
//  ReadNFCViewController.swift
//  NFCTimerOW
//
//  Created by Beatrix Kang on 24/02/2023.
//

import UIKit
import CoreNFC

class ReadNFCViewController: UIViewController {
  
    
    var timeString = ""
    var project : ProjectModel!
    let nfcReader = NFCReader()

    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var projectLabel: UILabel!
    @IBOutlet var timerView: UILabel!
    @IBOutlet var endTaskBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        nfcReader.delegate = self
        TimerManager.shared.delegate = self
        projectLabel.text = ProjectModel.sharedProject.projectC
        taskLabel.text = ProjectModel.sharedProject.taskC
        
        
        if !TimerManager.shared.isRunning {
            nfcReader.begin()
        }
    }
    
    
    @IBAction func scanButton(_ sender: UIButton) {
            nfcReader.begin()
    }
    
    
    
    
    
  
}

extension ReadNFCViewController : TimerManagerDelegate{
    func timerManager(_ timerManager: TimerManager, didUpdateElapsedTime elapsedTime: TimeInterval) {
        timeString = TimerManager.shared.timeConversion(elapsedTime: elapsedTime)
        timerView.text = timeString
        print (timeString)
    }
    
    
}

extension ReadNFCViewController: NFCReaderDelegate {
   
    
    func didReceive(payload: String) {
        
        
        guard let jsonData = JSONManager().getJsonData(payload: payload) else {
            print("Failed to convert string to data")
            self.present(PopUp().wrongCard(), animated: true, completion: nil)
            return
        }
        
        let jsonObject = JSONManager().getJsonObjectField(jsonData: jsonData)
        //need to assign to an external object so it can show
        
        let readProjectC = jsonObject["projectCode"]as? String ?? ""
        let readTaskC = jsonObject["taskCode"] as? String ?? ""
        
        //Valid Card + Timer Not Running
        if (ProjectModel.sharedProject.projectC == "Project Code" && ProjectModel.sharedProject.taskC == "Task Code" && readProjectC != "" && readTaskC != "" ) {
            ProjectModel.sharedProject.projectC = readProjectC
            ProjectModel.sharedProject.taskC =  readTaskC
            projectLabel.text = ProjectModel.sharedProject.projectC
            taskLabel.text = ProjectModel.sharedProject.taskC
            TimerManager.shared.start()
        }
        
        //Valid Card + Timer Running
        else if (ProjectModel.sharedProject.projectC == jsonObject["projectCode"] as? String && ProjectModel.sharedProject.taskC == jsonObject["taskCode"] as? String) && TimerManager.shared.isRunning {
            self.present(PopUp().timerRunning(), animated: true, completion: nil)
        }
        
        //Valid Card + Timer Paused
        else if (ProjectModel.sharedProject.projectC == jsonObject["projectCode"] as? String && ProjectModel.sharedProject.taskC == jsonObject["taskCode"] as? String) && !TimerManager.shared.isRunning {
            self.present(PopUp().timerPaused(),animated:true, completion:nil)
        }
        
        //Invalid Card
        //Future Improvements = make it start another timer but stop previous timer 
        else {
            self.present(PopUp().wrongCard(), animated: true, completion: nil)
        }
        
        
    }
    
   
}
