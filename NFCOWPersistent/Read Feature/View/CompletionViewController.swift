//
//  CompletionViewController.swift
//  NFCOWPersistent
//
//  Created by Beatrix Kang on 09/03/2023.
//


import UIKit

class CompletionViewController: UIViewController {

    var project : String = ""
    var totalTimeString : String = ""
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var projectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.hidesBackButton = true
        projectLabel.text = project
        timeLabel.text = totalTimeString

    }
 
    @IBAction func backToHomePressed(_ sender: UIButton) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    

}

