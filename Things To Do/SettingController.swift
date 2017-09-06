//
//  SettingController.swift
//  Things To Do
//
//  Created by Kewal Kanojia on 29/07/17.
//  Copyright © 2017 Kewal Kanojia. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class SettingController: UITableViewController {
    
    var soundEffectSetting:String = "";
    
    @IBOutlet weak var soundSetting: UISwitch!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var changePasswordCell: UITableViewCell!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundEffectSetting = self.getSoundEffectSetting()
        if soundEffectSetting == "true" {
            soundSetting.setOn(true, animated: true)
        } else {
            soundSetting.setOn(false, animated: true)
        }
        if self.checkLogin(contactSegue: "") {
            userEmail.isHidden = false;
            logout.isHidden = false;
            userEmail.text = self.getEmailId();
            changePasswordCell.isHidden = false;
        } else {
            login.isHidden = false;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSoundEffectSetting(_ sender: Any) {
        if soundSetting.isOn {
            let soundEffect = "true"
            //accessibilitySwitch is the UISwitch in question
            UserDefaults.standard.set(soundEffect, forKey: "soundEffect")
        } else {
            let soundEffect = "false"
            UserDefaults.standard.set(soundEffect, forKey: "soundEffect")
        }
    }
    
    
    @IBAction func supportWebsite(_ sender: Any) {
        var url : NSURL?
        url = NSURL(string: "https://www.facebook.com/")
        UIApplication.shared.openURL(url! as URL)
    }
    
    
    @IBAction func rateThisApp(_ sender: Any) {
        var url : NSURL?
        url = NSURL(string: "https://www.google.co.in/")
        UIApplication.shared.openURL(url! as URL)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "sessionToken")
        UserDefaults.standard.removeObject(forKey: "skip")
//        UserDefaults.standard.removeObject(forKey: "userId")
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "login") as! LoginController
        self.show(desCV, sender: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "sessionToken")
        //            UserDefaults.standard.removeObject(forKey: "userId")
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "login") as! LoginController
        self.show(desCV, sender: nil)
    }
    
    

}
