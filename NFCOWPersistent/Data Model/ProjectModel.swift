//
//  ProjectModel.swift
//  NFCOWPersistent
//
//  Created by Beatrix Kang on 09/03/2023.
//

import Foundation
/*
class ProjectModel{
    
    static let sharedProject = ProjectModel()
    
    var projectC : String = "Project Code"
    var projectN : String = "Project Name"
    
    var jsonProject: String {
        let data = ["projectCode":projectC, "projectName":projectN]
        let json = try! JSONSerialization.data(withJSONObject: data, options: [])
        let jsonString = String(data: json, encoding: .utf8)!
        return jsonString
        
    }
    
    
}
*/

struct ProjectWriteModel{

    let projectC : String
    let projectN : String

    
    var jsonProject: String {
        let data = ["projectCode":projectC, "projectName":projectN]
        let json = try! JSONSerialization.data(withJSONObject: data, options: [])
        let jsonString = String(data: json, encoding: .utf8)!
        return jsonString
        
    }
    
    
}

