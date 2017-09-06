//
//  ViewTaskController.swift
//  Things To Do
//
//  Created by Kewal Kanojia on 29/07/17.
//  Copyright © 2017 Kewal Kanojia. All rights reserved.
//

import UIKit
import UserNotifications

class ViewTaskController: UIViewController {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDescription: UITextView!
    
    var taskTitleValue = String()
    var taskDescriptionValue = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle.text = taskTitleValue
        taskDescription.text = taskDescriptionValue
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareTask(_ sender: Any) {
        
        let shareContent:String = "Title: "+taskTitleValue+"\n\n"+"Description: "+taskDescriptionValue+"\n\n\nShare by Thing to do app."
        
        let activityVC = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true) { 
            print("shared")
        }
        
    }
    
}
