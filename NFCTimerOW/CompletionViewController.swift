//
//  CompletionViewController.swift
//  NFCTimerOW
//
//  Created by Beatrix Kang on 03/03/2023.
//

import UIKit

class CompletionViewController: UIViewController {

    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var projectLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.hidesBackButton = true
        projectLabel.text = ProjectModel.sharedProject.projectC
        taskLabel.text = ProjectModel.sharedProject.taskC
        timeLabel.text = TimerManager.shared.timeConversion(elapsedTime: TimerManager.shared.totalInterval)
       
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ProjectModel.sharedProject.projectC = "Project Code"
        ProjectModel.sharedProject.taskC = "Task Code"
        TimerManager.shared.totalInterval = 0
    }
    
    
    
    @IBAction func backToHomePressed(_ sender: UIButton) {
        ProjectModel.sharedProject.projectC = "Project Code"
        ProjectModel.sharedProject.taskC = "Task Code"
        TimerManager.shared.totalInterval = 0
        self.navigationController!.popToRootViewController(animated: true)
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

