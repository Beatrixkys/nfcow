//
//  NFCWriterUtility.swift
//  NFCTimerOW
//
//  Created by Beatrix Kang on 24/02/2023.
//

import Foundation
import CoreNFC


protocol NFCWriterDelegate{
    
    func didWrite(payload:String)
}

class NFCWriter: NSObject {
    var delegate: NFCWriterDelegate?
    var messageToWrite: NFCNDEFMessage?
    var messageWritten = false
    private var session: NFCNDEFReaderSession?
   
    
    func begin() {
        session = NFCNDEFReaderSession(delegate: self,
                                       queue: nil,
                                       invalidateAfterFirstRead: false)
        session?.begin()
    }

    
    
    
    
}


extension NFCWriter: NFCNDEFReaderSessionDelegate {
    
    
    func readerSession(_ session: NFCNDEFReaderSession,
                       didDetectNDEFs messages: [NFCNDEFMessage]) {
//        messages.forEach { message in
//            message.records.forEach { record in
//                if let string = String(data: record.payload, encoding: .utf8) {
//                    delegate?.didWrite(payload: string)
//                }
//            }
//        }
    }
    
    
    
    func readerSession(_ session: NFCNDEFReaderSession,
                       didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
    func writeToTag(message:NFCNDEFMessage, tag: NFCNDEFTag){
        tag.writeNDEF(message) {error in
            if error != nil {
                print("Error writing NDEF message: \(error!)")
            } else {
                //self.messageWritten = true
                print("NDEF message written successfully!")
                self.session?.invalidate()
                //self.delegate?.didWrite(payload: "Success")
               
                
            }
        }
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        let tag = tags.first!
        
     
          
        //let tagModel = ProjectModel(projectC:"5564", taskC: "88899")
        //let message = createJson(jsonString: tagModel.jsonProject)
        //let message = NFCNDEFMessage(records: [ NFCNDEFPayload.wellKnownTypeTextPayload(string: "Hello, world!", locale: .current)! ])
        session.connect(to:tag){
            error in
                if error != nil {
                    print("Error connecting: \(error!)")
                } else {
                    print("Tag connected!")
                    self.writeToTag(message: self.messageToWrite!, tag: tag)
                    
                }
            
            
        }
        
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
            print("Started scanning for tags")
        }
    
    
}
