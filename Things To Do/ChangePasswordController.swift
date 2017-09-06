//
//  ChangePasswordController.swift
//  Things To Do
//
//  Created by Kewal Kanojia on 30/07/17.
//  Copyright © 2017 Kewal Kanojia. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController {

    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changePassword(_ sender: Any) {
        if (self.oldPassword.text?.isEmpty)! {
            errorMsg.isHidden = false
            errorMsg.text = "Old password can not be blank."
        } else if (self.password.text?.isEmpty)! {
            errorMsg.isHidden = false
            errorMsg.text = "Password can not be blank."
        } else {
            let oldPassword = self.oldPassword.text!
            let password = self.password.text!
            let userId = self.getUserId()
        
            let postString = "userId=\(userId)&password=\(password)&oldPassword=\(oldPassword)"
            let changePasswordResp = doHttpRequest(url: "changePassword.php", method: "POST", params: postString);
            let status = changePasswordResp?["status"] as! String
            if(status == "false") {
                errorMsg.isHidden = false
                errorMsg.text = changePasswordResp?["error"] as? String
            } else {
                errorMsg.isHidden = false
                errorMsg.text = "Password Change successfully."
            }
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
