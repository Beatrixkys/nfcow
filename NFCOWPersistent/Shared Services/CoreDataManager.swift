//
//  CoreDataManager.swift
//  NFCOWPersistent
//
//  Created by Beatrix Kang on 09/03/2023.
//
import Foundation
import CoreData
import UIKit

class TimerCoreDataManager{
    static let shared = TimerCoreDataManager()
    let context: NSManagedObjectContext
    let appDelegate : AppDelegate
    
    
    init() {
            appDelegate = UIApplication.shared.delegate as! AppDelegate
            context = appDelegate.persistentContainer.viewContext
        }
    
    func createTimerRecord(date : Date, projectModel: String, projectName:String) {
        let entity = NSEntityDescription.entity(forEntityName: "TimeEntity", in: context)
        let newTimer = NSManagedObject(entity: entity!, insertInto: context)
        
        newTimer.setValue(date, forKey: "startTime")
        newTimer.setValue(projectModel, forKey: "projectModel")
        newTimer.setValue(projectName, forKey: "projectName")
        newTimer.setValue(true, forKey: "isRunning")
        
        do {
            try context.save()
            print (newTimer)
          } catch {
            print("Error saving timer data: \(error)")
          }
        
    }
    
    func updateStartTimeRecord(date: Date){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntity")
        //request.predicate = NSPredicate(format: "projectModel == %@ ", projectModel)
        do {
                    let result = try context.fetch(request)
                    for data in result as? [NSManagedObject] ?? []
                            //it is printing an entire array instead of one object
        {
                        data.setValue(date, forKey: "startTime")
          }
               } catch {

                   print("Failed Update")
        }
        
    }
    
    func updateStatusRecord(status: Bool){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntity")
        //request.predicate = NSPredicate(format: "projectModel == %@ ", projectModel)
        do {
                    let result = try context.fetch(request)
                    for data in result as? [NSManagedObject] ?? []
                            //it is printing an entire array instead of one object
        {
                        data.setValue(status, forKey: "isRunning")
          }
               } catch {

                   print("Failed Update")
        }
        
    }
    
    func updatePauseTimeRecord(pause: Date){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntity")
        //request.predicate = NSPredicate(format: "projectModel == %@ ", projectModel)
        do {
                    let result = try context.fetch(request)
                    for data in result as? [NSManagedObject] ?? []
                            //it is printing an entire array instead of one object
        {

                        data.setValue(pause, forKey: "pauseTime")
          }
               } catch {

                   print("Failed Update")
        }
        
    }
    
    func updatePauseAsNil(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntity")
        //request.predicate = NSPredicate(format: "projectModel == %@ ", projectModel)
        do {
                    let result = try context.fetch(request)
                    for data in result as? [NSManagedObject] ?? []
                            //it is printing an entire array instead of one object
        {

                        data.setValue(nil, forKey: "pauseTime")
          }
               } catch {

                   print("Failed Update")
        }
        
    }
    
    //fetch functionality
    func fetchTimerExistence() -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntity")
        request.returnsObjectsAsFaults = false
        var resultFirst : NSManagedObject? = nil
        do {
            let result = try context.fetch(request)
            resultFirst = result.first as? NSManagedObject ?? nil
            print (result)
            //return dateShow
               } catch {

                   print("Failed")
        }
        
        return resultFirst
    }
    
    func fetchTimerProject() -> String {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntity")
        
        var projectModel = ""
        request.returnsObjectsAsFaults = false
        do {
                    let result = try context.fetch(request)
            let resultFirst = result.first as! NSManagedObject
           
            projectModel = resultFirst.value(forKey: "projectModel") as! String
            //return dateShow
               } catch {
                   print("Failed Return Start Date")
        }
        return projectModel
    }
    
    func fetchTimerName() -> String {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntity")
        
        var projectName = ""
        request.returnsObjectsAsFaults = false
        do {
                    let result = try context.fetch(request)
            let resultFirst = result.first as! NSManagedObject
           
            projectName = resultFirst.value(forKey: "projectName") as! String
            //return dateShow
               } catch {
                   print("Failed Return Start Date")
        }
        return projectName
    }
    
  
    
    
    
    func fetchTimerDate( dateString : String) -> Date? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntity")
        //request.predicate = NSPredicate(format: "projectModel == %@", projectModel)
        
        var date = Date ()
        request.returnsObjectsAsFaults = false
        do {
                    let result = try context.fetch(request)
            let resultFirst = result.first as! NSManagedObject
            date = resultFirst.value(forKey: dateString) as! Date
            //return dateShow
               } catch {
                   print("Failed Return Start Date")
        }
        return date
    }
    
    func fetchTimerStatusFirst() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntity")
        
        var status = false
        request.returnsObjectsAsFaults = false
        do {
                    let result = try context.fetch(request)
            let resultFirst = result.first as! NSManagedObject
            status = resultFirst.value(forKey: "isRunning") as? Bool ?? false
            //return dateShow
               } catch {

                   print("Failed Return Status")
        }
        
        return status
    }
    
    
    func deleteTimerData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntity")
        //request.predicate = NSPredicate(format: "projectModel = %@", projectModel)
        do {
                    let result = try context.fetch(request)
            
            
            
                    for data in result as? [NSManagedObject] ?? []
                            //it is printing an entire array instead of one object
        {
                        context.delete(data)
          }
            
               } catch {

                   print("Failed Delete")
        }
        appDelegate.saveContext()
        
    }
    
    
    
}
