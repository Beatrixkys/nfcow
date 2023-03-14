//
//  JSONManager.swift
//  NFCOWPersistent
//
//  Created by Beatrix Kang on 09/03/2023.
//
import Foundation
import CoreNFC

struct  JSONManager{
    
    
    func createJsonNDEF(jsonString: String)-> NFCNDEFMessage{
        let payload = NFCNDEFPayload(format: .absoluteURI, type: "application/json".data(using: .utf8)!, identifier: Data.init(count: 0), payload: jsonString.data(using: .utf8)!)
        let message = NFCNDEFMessage(records: [ payload ])
        return message
    }
    
    
    func getJsonData(payload:String)->Data?{
        let jsonData = payload.data(using: .utf8)
        return jsonData
    }
    
    func getJsonObjectField (jsonData: Data?)->[String:Any]{
        
        do {
            if let jsonObj = try JSONSerialization.jsonObject(with: jsonData!, options: [])as? [String:Any]{
                return jsonObj
            }
        } catch {
            print("Failed to convert data to JSON object: \(error.localizedDescription)")
            
        }
        
        return ["":""]
    }
    
    
    
}
