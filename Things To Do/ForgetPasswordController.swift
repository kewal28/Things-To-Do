//
//  ForgetPasswordController.swift
//  Things To Do
//
//  Created by Kewal Kanojia on 31/07/17.
//  Copyright © 2017 Kewal Kanojia. All rights reserved.
//

import UIKit

class ForgetPasswordController: UIViewController {
    
    
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var forgetEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func forgetPassword(_ sender: Any) {
        if (self.forgetEmail.text?.isEmpty)! {
            errorMsg.isHidden = false
            errorMsg.text = "Email can not be blank."
        } else {
            let forgetEmail = self.forgetEmail.text!
        
            let postString = "forgetEmail=\(forgetEmail)"
            let forgetPasswordResp = doHttpRequest(url: "forgetPassword.php", method: "POST", params: postString);
            let status = forgetPasswordResp?["status"] as! String
            if(status == "false") {
                errorMsg.isHidden = false
                errorMsg.text = forgetPasswordResp?["error"] as? String
            } else {
                errorMsg.isHidden = false
                errorMsg.text = "Login Details send on your register email id."
            }
        }
    }
    
}
