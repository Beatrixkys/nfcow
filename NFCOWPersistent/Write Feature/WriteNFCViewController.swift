//
//  WriteNFCViewController.swift
//  NFCOWPersistent
//
//  Created by Beatrix Kang on 09/03/2023.
//


import UIKit
import CoreNFC

class WriteNFCViewController: UIViewController {

    var projectM : ProjectWriteModel!
    let nfcWriter = NFCWriter()
    
    @IBOutlet var projectName: UITextField!
    @IBOutlet var projectField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nfcWriter.delegate = self
        
        projectField.delegate  = self
        projectName.delegate = self
        
        projectField.keyboardType = .numberPad

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func writeButtonPressed(_ sender: UIButton) {
        
        if let project = projectField.text , let pName = projectName.text{
            let tagModel = ProjectWriteModel(projectC:project, projectN: pName)
            let message = JSONManager().createJsonNDEF(jsonString: tagModel.jsonProject)
            nfcWriter.messageToWrite = message
            nfcWriter.begin()
            
            
            
            
        }
        
      
        
            
       
    }

}
extension WriteNFCViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
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
