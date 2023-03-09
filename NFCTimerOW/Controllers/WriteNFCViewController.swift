//
//  WriteNFCViewController.swift
//  NFCTimerOW
//
//  Created by Beatrix Kang on 24/02/2023.
//

import UIKit
import CoreNFC

class WriteNFCViewController: UIViewController {

    var projectM : ProjectWriteModel!
    let nfcWriter = NFCWriter()
    
    @IBOutlet var taskField: UITextField!
    @IBOutlet var projectField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nfcWriter.delegate = self
        taskField.delegate = self
        projectField.delegate  = self

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func writeButtonPressed(_ sender: UIButton) {
        
        if let project = projectField.text, let task = taskField.text{
            let tagModel = ProjectWriteModel(projectC:project, taskC: task)
            let message = JSONManager().createJsonNDEF(jsonString: tagModel.jsonProject)
            nfcWriter.messageToWrite = message
            nfcWriter.begin()
            
            
            
            
        }
        
      
        
            
       
    }

}
extension WriteNFCViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskField.endEditing(true)
        projectField.endEditing(true)
        return true
    }}

extension WriteNFCViewController: NFCWriterDelegate{

    
    func didWrite(payload: String) {
        
//        let writeAlert = UIAlertController(title: "Tag is Written!", message: payload, preferredStyle: UIAlertController.Style.alert)
//        writeAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(writeAlert, animated: true, completion: nil)
        
        //self.present(PopUp().tagWritten(), animated: true, completion: nil)
    }
    
    
    
}
