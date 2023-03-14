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
  
    
    var timeString = ""
    var project : ProjectModel!
    let nfcReader = NFCReader()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var projectLabel: UILabel!
    @IBOutlet var timerView: UILabel!
    @IBOutlet var endTaskBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        nfcReader.delegate = self
        TimerManager.shared.delegate = self
        projectLabel.text = "Scan to Begin Timer"
       
        
        if TimerCoreDataManager().fetchTimerExistence() == nil {
            nfcReader.begin()
        } else if (TimerCoreDataManager().fetchTimerStatusFirst()){
            ProjectModel.sharedProject.projectC = TimerCoreDataManager().fetchTimerProject()
            print (TimerCoreDataManager().fetchTimerProject())
            
            ProjectModel.sharedProject.projectN = TimerCoreDataManager().fetchTimerName()
            ProjectModel.sharedProject.projectC = TimerCoreDataManager().fetchTimerProject()
            projectLabel.text = "\(ProjectModel.sharedProject.projectN)(\(ProjectModel.sharedProject.projectC))"
            TimerManager.shared.start()
        } else if !(TimerCoreDataManager().fetchTimerStatusFirst()){
            ProjectModel.sharedProject.projectN = TimerCoreDataManager().fetchTimerName()
            ProjectModel.sharedProject.projectC = TimerCoreDataManager().fetchTimerProject()
            projectLabel.text = "\(ProjectModel.sharedProject.projectN)(\(ProjectModel.sharedProject.projectC))"
            let elapsedTime = (TimerCoreDataManager().fetchTimerDate(dateString: "pauseTime") ?? Date()).timeIntervalSince(TimerCoreDataManager().fetchTimerDate(dateString: "startTime") ?? Date() )
            timerView.text = TimerManager().timeConversion(elapsedTime: elapsedTime)
        } else {
           print ("Hello this not work")
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
        let readProjectN = jsonObject["projectName"]as? String ?? ""
        
        
        
        //Valid Card + CoreTimer Not Created
        if (TimerCoreDataManager.shared.fetchTimerExistence() == nil && readProjectC != "" && readProjectN != "") {
            
            //ProjectModel.sharedProject.projectC = readProjectC
            //ProjectModel.sharedProject.taskC =  readTaskC
            projectLabel.text = "\(readProjectN)(\(readProjectC))"
           
            TimerCoreDataManager().createTimerRecord(date: Date(), projectModel: readProjectC, projectName: readProjectN)
            
            TimerManager.shared.start()
            
        }
        
        
        //Valid Card + CoreTimer Created + Card Read = Core Data Info + Core Timer Running
        
        else if (TimerCoreDataManager().fetchTimerProject() == jsonObject["projectCode"] as? String && TimerCoreDataManager().fetchTimerStatusFirst() ){
            
            self.present(PopUp().timerRunning(), animated: true, completion: nil)
        }
        
        //Valid Card + Timer Paused
        else if (TimerCoreDataManager().fetchTimerProject() == jsonObject["projectCode"] as? String && !TimerCoreDataManager.shared.fetchTimerStatusFirst() ){
            
            self.present(PopUp().timerPaused(),animated:true, completion:nil)
        }
        
        //Invalid Card
        //Future Improvements = make it start another timer but stop previous timer
        else {
            self.present(PopUp().wrongCard(), animated: true, completion: nil)
        }
        
        
    }
    
    
      
    
    
   
}
