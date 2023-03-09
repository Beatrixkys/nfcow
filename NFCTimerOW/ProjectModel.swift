//
//  ProjectModel.swift
//  NFCTimerOW
//
//  Created by Beatrix Kang on 27/02/2023.
//

import Foundation

class ProjectModel{
    
    static let sharedProject = ProjectModel()
    
    var projectC : String = "Project Code"
    var taskC: String = "Task Code"

    
    var jsonProject: String {
        let data = ["projectCode":projectC, "taskCode":taskC]
        let json = try! JSONSerialization.data(withJSONObject: data, options: [])
        let jsonString = String(data: json, encoding: .utf8)!
        return jsonString
        
    }
    
    
}

struct ProjectWriteModel{

    let projectC : String
    let taskC: String 

    
    var jsonProject: String {
        let data = ["projectCode":projectC, "taskCode":taskC]
        let json = try! JSONSerialization.data(withJSONObject: data, options: [])
        let jsonString = String(data: json, encoding: .utf8)!
        return jsonString
        
    }
    
    
}
