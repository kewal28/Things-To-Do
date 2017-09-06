//
//  AddTaskController.swift
//  Things To Do
//
//  Created by Kewal Kanojia on 28/07/17.
//  Copyright © 2017 Kewal Kanojia. All rights reserved.
//

import UIKit
import AVFoundation

class AddTaskController: UIViewController {
    
    var player:AVAudioPlayer = AVAudioPlayer()
    var soundEffectSetting:String = "";
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var taskTitleError: UIImageView!
    @IBOutlet weak var taskDescriptionError: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMsg.isHidden = true
        taskTitleError.isHidden = true
        taskDescriptionError.isHidden = true
        soundEffectSetting = self.getSoundEffectSetting()
        if soundEffectSetting == "true" {
            do {
                let audioPath = Bundle.main.path(forResource: "braked", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            } catch let error {
                print(error)
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        let borderColor = self.uicolorFromHex(rgbValue: 0x000000)
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: taskTitle.frame.size.height - width, width:  taskTitle.frame.size.width, height: taskTitle.frame.size.height)
        
        border.borderWidth = width
        taskTitle.layer.addSublayer(border)
        taskTitle.layer.masksToBounds = true
        
        let descriptionBorder = CALayer()
        let descriptionwidth = CGFloat(1.0)
        descriptionBorder.borderColor = borderColor.cgColor
        descriptionBorder.frame = CGRect(x: 0, y: taskDescription.frame.size.height - descriptionwidth, width:  taskDescription.frame.size.width, height: taskDescription.frame.size.height)
        
        descriptionBorder.borderWidth = descriptionwidth
        
        taskDescription.layer.addSublayer(descriptionBorder)
        taskDescription.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTask(_ sender: Any) {
        if(taskTitle.text?.isEmpty)! {
            taskTitleError.isHidden = false
            errorMsg.isHidden = false
            errorMsg.text = "Title can not be blank."
            taskTitle.becomeFirstResponder()
        } else if(taskDescription.text?.isEmpty)! {
            taskDescriptionError.isHidden = false
            errorMsg.isHidden = false
            errorMsg.text = "Description can not be blank."
            taskDescription.becomeFirstResponder()
        } else {
            taskTitleError.isHidden = true
            taskDescriptionError.isHidden = true
            errorMsg.isHidden = true
            let addTaskLoading = self.displayLoading();
            //Add Task Request
            let userId:String = self.getUserId()
            let postString = "taskTitle=\(taskTitle.text!)&taskDescription=\(taskDescription.text!)&userId=\(userId)"
            let addTaskResp = doHttpRequest(url: "addTask.php", method: "POST", params: postString);
            if !((addTaskResp?.isEmpty)!) {
                let status = addTaskResp?["status"] as! String
                if(status == "false") {
                    errorMsg.isHidden = false
                    errorMsg.text = addTaskResp?["error"] as? String
                } else {
                    addTaskLoading.dismiss(animated: false, completion: {
                        if self.soundEffectSetting == "true" {
                            self.player.play()
                        }
                        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "taskList") as! TaskListController
                        self.show(desCV, sender: nil)
                    })
                }
            } else {
                errorMsg.isHidden = false
                errorMsg.text = "Error while adding task."
            }
            addTaskLoading.dismiss(animated: false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    


}

