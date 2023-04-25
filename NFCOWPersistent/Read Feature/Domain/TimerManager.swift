//
//  TimerManager.swift
//  NFCOWPersistent
//
//  Created by Beatrix Kang on 09/03/2023.
//

import Foundation
import UIKit


protocol TimerManagerDelegate: AnyObject {
    func timerManager(_ timerManager: TimerManager, didUpdateElapsedTime elapsedTime: TimeInterval)
}



class TimerManager {
    static let shared = TimerManager()
    
    //core data implement
    //private var coreData : TimerCoreDataManager?
    
    //to create timer instance
    var timer: Timer?
    
    //to detect when the time is started
    private var startTime: Date?
    
    //to calculate based on when the time is paused
    private var pauseTime: Date?
    private var pauseInterval: TimeInterval = 0
    
    //for cross function access
    var totalInterval : TimeInterval = 0
    private var isRunning: Bool = false
    
    
    weak var delegate: TimerManagerDelegate?
    
    
    func start() {
        
        let date = TimerCoreDataManager().fetchDate(key: "startTime") ?? Date()
        startTime = date
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let elapsedTime = Date().timeIntervalSince(self.startTime!)
            self.delegate?.timerManager(self, didUpdateElapsedTime: elapsedTime)
        }
        self.isRunning = true
    }
    
    func pause(){
        pauseTime = Date()
        //pauseInterval = pauseTime!.timeIntervalSince(startTime!)
        timer?.invalidate()
        self.isRunning = false
        
        TimerCoreDataManager().updateBoolRecord(key: "isRunning", status:self.isRunning)
        TimerCoreDataManager().updateTimeRecord(key: "pauseTime", date: pauseTime ?? Date())
        
    }
    
    func resume(){
        
        pauseInterval = pausedIntervalCalc()
        
        self.startTime = Date().addingTimeInterval(-pauseInterval)
        TimerCoreDataManager().updateTimeRecord(key:"startTime",date: startTime ?? Date())
        
        self.pauseTime = nil
        self.pauseInterval = 0
        TimerCoreDataManager().updateTimeRecord(key: "pauseTime", date: nil)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let elapsedTime = Date().timeIntervalSince(self.startTime!)
            self.delegate?.timerManager(self, didUpdateElapsedTime: elapsedTime)
        }
        
        self.isRunning = true
        TimerCoreDataManager().updateBoolRecord(key: "isRunning", status:self.isRunning)
    }
    
    func stop() {
        timer?.invalidate()
        totalInterval = Date().timeIntervalSince(TimerCoreDataManager().fetchDate(key: "startTime") ?? Date())
        
        timer = nil
        startTime = nil
        pauseTime = nil
        pauseInterval = 0
        self.isRunning = false
        TimerCoreDataManager().deleteTimerData()
        
        if let sourceViewController = delegate as? UIViewController {
                   sourceViewController.performSegue(withIdentifier: "readToCompleteSegue", sender: nil)
                
               } else {
                   print("Error: delegate is not a UIViewController")
               }
    }
    
    func pausedIntervalCalc() -> TimeInterval{
        let elapsedTime = (TimerCoreDataManager().fetchDate(key: "pauseTime") ?? Date()).timeIntervalSince(TimerCoreDataManager().fetchDate(key: "startTime") ?? Date() )
        return elapsedTime
    }
    func timeConversion(elapsedTime: TimeInterval)->String{
        let formatter = DateComponentsFormatter()
        //let formatter = DateFormatter()
        //formatter.dateFormat = ""
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        let formattedString = formatter.string(from: elapsedTime)
        return formattedString!
    }
}
