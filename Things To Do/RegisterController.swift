//
//  RegisterController.swift
//  Shopping
//
//  Created by Kewal Kanojia on 12/03/17.
//  Copyright © 2017 Kewal Kanojia. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    
    private let ContactSegue = "taskListNav"

    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var nameError: UIImageView!
    @IBOutlet weak var emailError: UIImageView!
    @IBOutlet weak var passwordError: UIImageView!
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var mobileError: UIImageView!
    
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
    
    @IBAction func registerUser(_ sender: Any) {
        if(nameTxt.text == "") {
            errorMsg.isHidden = false
            errorMsg.text = "Please enter first name."
            nameError.isHidden = false
            nameTxt.becomeFirstResponder()
        } else if(emailTxt.text == "") {
            nameError.isHidden = true
            errorMsg.isHidden = false
            errorMsg.text = "Please enter email."
            emailError.isHidden = false;
            emailTxt.becomeFirstResponder()
        } else if(mobileTxt.text == "") {
            emailError.isHidden = true
            errorMsg.isHidden = false
            errorMsg.text = "Please enter email."
            mobileError.isHidden = false;
            mobileTxt.becomeFirstResponder()
        } else if(passwordTxt.text == "") {
            emailError.isHidden = true
            errorMsg.isHidden = false
            errorMsg.text = "Please enter password."
            passwordError.isHidden = false;
            passwordTxt.becomeFirstResponder()
        } else {
            errorMsg.isHidden = true
            nameError.isHidden = true
            emailError.isHidden = true
            passwordError.isHidden = true
            
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.color = UIColor.darkGray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            //Register Request
            
            let name = nameTxt.text!
            let email = emailTxt.text!
            let password = passwordTxt.text!
            let phoneno = mobileTxt.text!
            let userId = self.getUserId()
            
            let postString = "userId=\(userId)&name=\(name)&email=\(email)&password=\(password)&phoneno=\(phoneno)"
            let registerResp = doHttpRequest(url: "signup.php", method: "POST", params: postString);
            let status = registerResp?["status"] as! String
            if(status == "false") {
                errorMsg.isHidden = false
                errorMsg.text = registerResp?["error"] as? String
            } else {
                let sessionToken = registerResp?["sessionToken"] as! String
                let userId = registerResp?["userId"] as! String
                let emailId = registerResp?["emailId"] as! String
                UserDefaults.standard.set(sessionToken, forKey: "sessionToken")
                UserDefaults.standard.set(userId, forKey: "userId")
                UserDefaults.standard.set(emailId, forKey: "emailId")
                self.performSegue(withIdentifier: self.ContactSegue, sender: self)
            }
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
        }
        
    }
    
    @IBAction func skip(_ sender: Any) {
        let skip:String = "true"
        UserDefaults.standard.set(skip, forKey: "skip")
        self.performSegue(withIdentifier: self.ContactSegue, sender: self)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskList" {
            if segue.destination is TaskListController {
                //viewController.property = property
            }
        }
    }
    

}
