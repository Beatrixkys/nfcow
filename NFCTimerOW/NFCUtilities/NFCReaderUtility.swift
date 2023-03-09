//
//  NFCReaderUtility.swift
//  NFCTimerOW
//
//  Created by Beatrix Kang on 24/02/2023.
//

import Foundation
import CoreNFC


protocol NFCReaderDelegate{
    
    
    func didReceive(payload:String)
}

class NFCReader: NSObject {
    var delegate: NFCReaderDelegate?
    private var session: NFCNDEFReaderSession?
   
    func begin() {
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main,invalidateAfterFirstRead: false)
        session?.begin()
    }

    
}


extension NFCReader: NFCNDEFReaderSessionDelegate {
   
    
    func readerSession(_ session: NFCNDEFReaderSession,
                       didDetectNDEFs messages: [NFCNDEFMessage]) {
       
        messages.forEach { message in
            message.records.forEach { record in
                if let string = String(data: record.payload, encoding: .utf8) {
                    delegate?.didReceive(payload: string)
                }
            }
        }
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession,
                       didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
            print("Started scanning for tags")
        }
    
}

