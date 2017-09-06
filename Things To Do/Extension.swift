//
//  Extension.swift
//  Shopping
//
//  Created by Kewal Kanojia on 12/04/17.
//  Copyright © 2017 Kewal Kanojia. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    
    func baseUrl() -> String {
//        return "http://localhost/Things-To-Do-Api/";
        return "http://dlcl.in/Things-To-Do-Api/";
    }
    
    
    func doHttpRequest(url: String, method:String, params:String) -> [String: Any]? {
        let apiUrl = self.baseUrl()+url;
        print("Url:- "+apiUrl)
        print("Method:- "+method)
        print("Params:- "+params)
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = method
        let semaphore = DispatchSemaphore(value: 0)
        if method != "GET" {
            request.httpBody = params.data(using: .utf8)
        }
        var resp:[String: Any] = [:];
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                resp = json!
            } catch let error {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        print("Resp")
        print(resp)
        return resp;
    }
    
    func checkLogin(contactSegue: String) -> Bool {
        var ret:Bool = false;
        if let sessionToken = UserDefaults.standard.object(forKey: "sessionToken") as? String {
            if !sessionToken.isEmpty {
                print(sessionToken)
                if !contactSegue.isEmpty {
                    self.performSegue(withIdentifier: contactSegue, sender: nil);
                } else {
                    ret = true;
                }
            }
        }
        return ret
    }
    
    func getUserId() -> String {
        var userId:String = "";
        if let userIdValue = UserDefaults.standard.object(forKey: "userId") as? String {
            if !userIdValue.isEmpty {
                userId = userIdValue
            }
        } else {
            let randomNum:UInt32 = arc4random_uniform(99999999) // range is 0 to 99999999
            userId = String(randomNum)
            UserDefaults.standard.set(userId, forKey: "userId")
        }
        print(userId)
        return userId
    }
    
    func getEmailId() -> String {
        var emailId:String = "";
        if let emailIdValue = UserDefaults.standard.object(forKey: "emailId") as? String {
            if !emailIdValue.isEmpty {
                emailId = emailIdValue
            }
        }
        print(emailId)
        return emailId
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayLoading() -> UIAlertController {
        //create an alert controller
        let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
        let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func getSoundEffectSetting() -> String {
        var soundEffectSetting:String = "";
        if let soundEffect = UserDefaults.standard.object(forKey: "soundEffect") as? String {
            if !soundEffect.isEmpty {
                soundEffectSetting = soundEffect
            }
        } else {
            let soundEffect:String = "true"
            UserDefaults.standard.set(soundEffect, forKey: "soundEffect")
            soundEffectSetting = soundEffect
        }
        print(soundEffectSetting)
        return soundEffectSetting
    }
    
    
}
