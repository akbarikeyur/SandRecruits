//
//  ForgotPasswordVC.swift
//  SandRecruits
//
//  Created by PC on 27/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet var emailTxt: TextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Player
        emailTxt.text = "npattison14@gmail.com"
        
        //Coach credentials:
//        emailTxt.text = "torogers@calpoly.edu"
    }
    
    //MARK: - Button click
    @IBAction func clickToResetPassword(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed.count == 0 {
            displayToast(NSLocalizedString("enter_email", comment: ""))
        }
        else if !emailTxt.text!.isValidEmail {
            displayToast(NSLocalizedString("invalid_email", comment: ""))
        }
        else {
            var param : [String  :Any] = [String : Any]()
            param["user_login"] = emailTxt.text?.trimmed
            
            APIManager.shared.serviceCallToForgotPassword(param) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
