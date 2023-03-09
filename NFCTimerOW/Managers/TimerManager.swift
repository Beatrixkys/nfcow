//
//  TimerManager.swift
//  NFCTimerOW
//
//  Created by Beatrix Kang on 28/02/2023.
//

import Foundation
import UIKit


protocol TimerManagerDelegate: AnyObject {
    func timerManager(_ timerManager: TimerManager, didUpdateElapsedTime elapsedTime: TimeInterval)
}



class TimerManager {
    static let shared = TimerManager()
    
    //to create timer instance
    private var timer: Timer?
    
    //to detect when the time is started
    private var startTime: Date?
    
    //to calculate based on when the time is paused
    private var pauseTime: Date?
    private var pauseInterval: TimeInterval = 0
    
    //for cross function access
    var totalInterval : TimeInterval = 0
    var isRunning: Bool = false
    
    
    weak var delegate: TimerManagerDelegate?
    
    
    func start() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let elapsedTime = Date().timeIntervalSince(self.startTime!)
            self.delegate?.timerManager(self, didUpdateElapsedTime: elapsedTime)
            
        }
        self.isRunning = true
    }
    
    func pause(){
        pauseTime = Date()
        pauseInterval = pauseTime!.timeIntervalSince(startTime!)
        timer?.invalidate()
        self.isRunning = false
    }
    
    func resume(){
        self.startTime = Date().addingTimeInterval(-self.pauseInterval)
        self.pauseTime = nil
        self.pauseInterval = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let elapsedTime = Date().timeIntervalSince(self.startTime!)
            self.delegate?.timerManager(self, didUpdateElapsedTime: elapsedTime)
        }
        self.isRunning = true
    }
    
    func stop() {
        timer?.invalidate()
        totalInterval = Date().timeIntervalSince(startTime!)
        timer = nil
        startTime = nil
        pauseTime = nil
        pauseInterval = 0
        
        self.isRunning = false
        
        if let sourceViewController = delegate as? UIViewController {
                   sourceViewController.performSegue(withIdentifier: "readToCompleteSegue", sender: nil)
               } else {
                   print("Error: delegate is not a UIViewController")
               }
    }
    
    func timeConversion(elapsedTime: TimeInterval)->String{
        let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        let formattedString = formatter.string(from: elapsedTime)
        return formattedString!
    }
}
