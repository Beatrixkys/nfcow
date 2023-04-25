//
//  ReadViewModel.swift
//  NFCOWPersistent
//
//  Created by Beatrix Kang on 16/03/2023.
//


import Foundation

class ReadNFCViewModel{
    
    
    
    var timeString:String = ""
    //var totalTimeString:String = ""
    var payload : String = ""
    private var readProjectC:String = ""
    private var readProjectN:String = ""
    
    var jsonData : Data? = nil
    var jsonObject : [String:Any] = [:]
    
    func timerUpdated(elapsedTime:TimeInterval) -> String {
        self.timeString = TimerManager.shared.timeConversion(elapsedTime: elapsedTime)
        return self.timeString
    }
    
    func assignProjectFromCore(){
        self.readProjectN = TimerCoreDataManager().fetchString(key: "projectName")
        self.readProjectC = TimerCoreDataManager().fetchString(key: "projectModel")
    }
    
    func assignPausedTimeFromCore(){
        let elapsedTime = TimerManager().pausedIntervalCalc()
        self.timeString = TimerManager().timeConversion(elapsedTime: elapsedTime)
    }
    
    var totalTimeString : String {
        let elapsedTime = TimerManager.shared.totalInterval
        TimerManager.shared.totalInterval = 0
        return TimerManager().timeConversion(elapsedTime: elapsedTime)
       
    }
    
    func jsonObject(payload:String) -> [String:Any] {
        self.jsonData = JSONManager().getJsonData(payload: payload)
        self.jsonObject = JSONManager().getJsonObjectField(jsonData: self.jsonData)
        self.readProjectC = jsonObject["projectCode"]as? String ?? ""
        self.readProjectN = jsonObject["projectName"]as? String ?? ""
        print (self.readProjectN)
        return self.jsonObject
    }
    
    
    var projectString:String {
        if self.readProjectC == ""{
            return "Scan to Begin Timer"
        } else {
            return ("\(readProjectN)(\(readProjectC))")

        }
    }
    
    
    
    func startTimerFirstTime (){
        TimerCoreDataManager().createTimerRecord(date: Date(), projectModel: self.readProjectC, projectName: self.readProjectN)
        TimerManager.shared.start()
    }
   
    func startTimerAfterClose (){
        TimerManager.shared.start()
    }
  
    
    
    
    
    
    
    
    
    // returning conditionals
    
    
    var jsonDataValid : Bool{
        print (self.readProjectN)
        if self.readProjectN != "" || self.readProjectC != ""{
            return true
        } else{
            return false
        }
    }
    
    
    
    
    var sameCardScanned : Bool{
        if TimerCoreDataManager().fetchString(key: "projectModel" ) == self.readProjectC{
            return true
        }else {
            return false
        }
    }
    
    
    var timerNotCreated : Bool{
        if TimerCoreDataManager.shared.fetchCoreTimer() == nil{
            return true
        } else {
            return false
        }
    }
    var timerRunning : Bool {
        if TimerCoreDataManager().fetchBool(key: "isRunning") {
            return true
        } else{
            return false
        }
        //return true
    }
    
    
}

