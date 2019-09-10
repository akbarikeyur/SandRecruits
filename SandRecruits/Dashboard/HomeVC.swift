//
//  HomeVC.swift
//  SandRecruits
//
//  Created by PC on 27/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblView: UITableView!
    @IBOutlet weak var nameLbl: Label!
    
    var playerArr = ["My Profile","Edit Profile","Events","College Search"]
    var coachArr = ["My Dashboard","College Dashboard","Events","Athlete Search"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.register(UINib(nibName: "HomeTVC", bundle: nil), forCellReuseIdentifier: "HomeTVC")
        
        nameLbl.text = AppModel.shared.currentUser.fname
        if AppModel.shared.currentUser.lname.trimmed != ""
        {
            nameLbl.text = nameLbl.text! + " " + AppModel.shared.currentUser.lname
        }
    }
    
    //MARK: - Button click
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.menuContainerViewController.toggleRightSideMenuCompletion {
            
        }
    }
    
    
    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isPlayerLogin() ? playerArr.count : coachArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        cell.titleLbl.text = isPlayerLogin() ? playerArr[indexPath.row] : coachArr[indexPath.row]
        cell.infoBtn.tag = indexPath.row
        cell.infoBtn.addTarget(self, action: #selector(clickToInfoBtn(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            if isPlayerLogin()
            {
                let vc : OtherUserProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc : CoachDashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "CoachDashboardVC") as! CoachDashboardVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if indexPath.row == 1 {
            if isPlayerLogin()
            {
                openUrlInSafari(strUrl: Edit_Player_Profile)
                /*
                let vc : AppWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "AppWebViewVC") as! AppWebViewVC
                vc.strUrl = Edit_Player_Profile
                self.navigationController?.pushViewController(vc, animated: true)
                */
            }
            else
            {
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
    }
    
    @IBAction func clickToInfoBtn(_ sender: UIButton) {
        var strMessage : String = ""
        
        if isPlayerLogin()
        {
            switch sender.tag {
            case 0:
                strMessage = "View and share your athlete profile."
                break
            case 1:
                strMessage = "Give coaches more reasons to recruit you by updating your profile information."
                break
            case 2:
                strMessage = "Check out recruiting tournaments, camps & clinics."
                break
            case 3:
                strMessage = "Learn about colleges with beach programs and get to know the coaches running them."
                break
            default:
                break
            }
        }
        else {
            switch sender.tag {
            case 0:
                strMessage = "View your tracked athletes and update your profile."
                break
            case 1:
                strMessage = "View athletes being tracked by others at your college."
                break
            case 2:
                strMessage = "View recruiting events and see attendees. View athlete info in real-time during tournaments with BracketPal."
                break
            case 3:
                strMessage = "Search for the perfect athlete using our many search filters and find your next recruit!"
                break
            default:
                break
            }
        }
        showAlert("", message: strMessage) {
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
