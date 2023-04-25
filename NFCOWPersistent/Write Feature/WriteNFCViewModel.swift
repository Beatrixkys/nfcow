//
//  WriteNFCViewModel.swift
//  NFCOWPersistent
//
//  Created by Beatrix Kang on 16/03/2023.
//

import Foundation
import CoreNFC

struct WriteNFCModel{
    var project : String
    var name : String
    //var projectM : ProjectWriteModel!
    let nfcWriter = NFCWriter()
    
    var tagModel:ProjectWriteModel {
      return ProjectWriteModel(projectC: project, projectN: name)
    }
    
    var message: NFCNDEFMessage {
        return JSONManager().createJsonNDEF(jsonString: tagModel.jsonProject)
    }
    
    func NFCBegin(){
        self.nfcWriter.messageToWrite = self.message
        self.nfcWriter.begin()
    }
    
    
}
