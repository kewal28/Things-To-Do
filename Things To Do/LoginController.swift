//
//  LoginController.swift
//  Shopping
//
//  Created by Kewal Kanojia on 12/03/17.
//  Copyright © 2017 Kewal Kanojia. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    
    private let ContactSegue = "taskListNav"
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailError: UIImageView!
    @IBOutlet weak var passwordError: UIImageView!
    @IBOutlet weak var errorMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let _ = self.checkLogin(contactSegue: self.ContactSegue)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Code
        let _ = self.checkLogin(contactSegue: self.ContactSegue)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //For alert Box 
    //self.createAlert(title: "Could not post image", message: "Please try again later")
    
    
    @IBAction func doLogin(_ sender: Any) {
        let signinLoading = self.displayLoading();
        if(emailTxt.text == "") {
            errorMsg.isHidden = false
            errorMsg.text = "Please enter email id."
            emailError.isHidden = false
            emailTxt.becomeFirstResponder()
        } else if(passwordTxt.text == "") {
            emailError.isHidden = true
            errorMsg.isHidden = false
            errorMsg.text = "Please enter password."
            passwordError.isHidden = false;
            passwordTxt.becomeFirstResponder()
        } else {
            errorMsg.isHidden = true
            emailError.isHidden = true
            passwordError.isHidden = true
            
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.color = UIColor.darkGray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            //Login Request
            let postString = "email=\(emailTxt.text!)&password=\(passwordTxt.text!)"
            let loginResp = doHttpRequest(url: "login.php", method: "POST", params: postString);
            if !((loginResp?.isEmpty)!) {
            let status = loginResp?["status"] as! String
            if(status == "false") {
                errorMsg.isHidden = false
                errorMsg.text = loginResp?["error"] as? String
            } else {
                let sessionToken = loginResp?["sessionToken"] as! String
                let userId = loginResp?["userId"] as! String
                let emailId = loginResp?["emailId"] as! String
                UserDefaults.standard.set(sessionToken, forKey: "sessionToken")
                UserDefaults.standard.set(userId, forKey: "userId")
                UserDefaults.standard.set(emailId, forKey: "emailId")
                signinLoading.dismiss(animated: false, completion: {
                    self.performSegue(withIdentifier: self.ContactSegue, sender: self)
                })
            }
            } else {
                errorMsg.isHidden = false
                errorMsg.text = "Error while login."
            }
            signinLoading.dismiss(animated: false)
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func skip(_ sender: Any) {
        let skip:String = "true"
        UserDefaults.standard.set(skip, forKey: "skip")
        self.performSegue(withIdentifier: self.ContactSegue, sender: self)
    }
    
    
}
