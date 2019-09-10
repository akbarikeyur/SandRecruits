//
//  LoginVC.swift
//  SandRecruits
//
//  Created by PC on 27/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet var emailTxt: TextField!
    @IBOutlet var passwordTxt: TextField!
    @IBOutlet weak var signupView: UIView!
    
    var isFailed : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.serviceCallToCheckSignupStatus()
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        if PLATFORM.isSimulator
        {
            //Player
//            emailTxt.text = "npattison14@gmail.com"
//            passwordTxt.text = "Fortnite"
            
            //Coach credentials:
            emailTxt.text = "torogers@calpoly.edu"
            passwordTxt.text = "s5pmd3ek"
            //            emailTxt.text = "info@sandrecruits.com"
            //            passwordTxt.text = "Volleyball2019"
        }
    }
    
    //MARK: - Button click
    @IBAction func clickToSignIn(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed.count == 0 {
            displayToast(NSLocalizedString("enter_email", comment: ""))
        }
        else if passwordTxt.text?.trimmed.count == 0 {
            displayToast(NSLocalizedString("enter_password", comment: ""))
        }
        else {
            var param : [String  :Any] = [String : Any]()
            param["email"] = emailTxt.text?.trimmed
            param["password"] = passwordTxt.text?.trimmed
            
            APIManager.shared.serviceCallToLoginUser(param) {
                AppDelegate().sharedDelegate().navigateToDashBoard()
            }
        }
    }
    
    @IBAction func clickToJoin(_ sender: Any) {
        self.view.endEditing(true)
        openUrlInSafari(strUrl: SIGNUP_URL)
    }
    
    @IBAction func clickToForgotPassword(_ sender: Any) {
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func serviceCallToCheckSignupStatus()
    {
        if isFailed {
            return
        }
        APIManager.shared.serviceCallToCheckSignupStatus { (value) in
            if value == 0
            {
                self.signupView.isHidden = true
            }
            else if value == 1
            {
                self.signupView.isHidden = false
            }
            else if value == -1
            {
                self.serviceCallToCheckSignupStatus()
                self.isFailed = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
