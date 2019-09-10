//
//  SideMenuVC.swift
//  SandRecruits
//
//  Created by PC on 27/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class sidemenuTVC: UITableViewCell {
    
    @IBOutlet var Lbl: UILabel!
}

class SideMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var sidemenuTblView: UITableView!
    
    var arrMenu : [String] = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isPlayerLogin()
        {
            arrMenu = ["My Profile","Edit Profile","Events","College Search","Log Out"]
        }
        else
        {
            arrMenu = ["My Dashboard","College Dashboard","Events","Athlete Search","Log Out"]
        }
    }
    
    //MARK: - TABLEVIEW DELEGATE METHODE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sidemenuTblView.dequeueReusableCell(withIdentifier: "sidemenuTVC", for: indexPath) as! sidemenuTVC
        cell.Lbl.text = arrMenu[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.menuContainerViewController.toggleRightSideMenuCompletion {
                
            }
        }
        
        if indexPath.row == 0 {
            if isPlayerLogin() {
                let vc : OtherUserProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc : CoachDashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "CoachDashboardVC") as! CoachDashboardVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.row == 1 {
            if isPlayerLogin() {
                openUrlInSafari(strUrl: Edit_Player_Profile)
                /*
                let vc : AppWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "AppWebViewVC") as! AppWebViewVC
                vc.strUrl = Edit_Player_Profile
                self.navigationController?.pushViewController(vc, animated: true)
                */
            } else {
                let vc : CoachCollegeDashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "CoachCollegeDashboardVC") as! CoachCollegeDashboardVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if indexPath.row == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3 {
            if isPlayerLogin()
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CollegeSearchVC") as! CollegeSearchVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoachAthleteSearchVC") as! CoachAthleteSearchVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if indexPath.row == 4 {
            showAlertWithOption("Logout", message: "Are you sure want to Logout?", completionConfirm: {
                AppDelegate().sharedDelegate().logout()
            }) {
                
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
