//
//  CustomDetailVC.swift
//  SandRecruits
//
//  Created by PC on 01/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CustomDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var collagePicBtn: Button!
    @IBOutlet weak var collageNameLbl: UILabel!
    @IBOutlet weak var collageStateLbl: Label!
    @IBOutlet weak var collageTypeLbl: Label!
    
    @IBOutlet var schoolInfoTblView: UITableView!
    @IBOutlet var schoolInfoTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var socialTblView: UITableView!
    @IBOutlet var socialTblViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var collegeInfoBackView: UIView!
    @IBOutlet var collegeInfoBtn: Button!
    @IBOutlet var collegeLbl: Label!
    @IBOutlet var coachBtn: Button!
    @IBOutlet var coachLbl: Label!
    
    @IBOutlet var playerTblView: UITableView!
    @IBOutlet var playerTblViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var coachInfoBackView: UIView!
    @IBOutlet weak var followBtn: Button!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var ContainerViewHeightConstraint: NSLayoutConstraint!

    var college_id : String = ""
    var arrSchoolInfo : [[String : String]] = [[String : String]]()
    var arrSocialInfo : [[String : String]] = [[String : String]]()
    
    var collageMainData : CollageMainModel = CollageMainModel.init()
    var collageInfoData : CollageInfoModel = CollageInfoModel()
    var arrCoachInfo : [CoachInfoModel] = [CoachInfoModel]()
    
    var isFollow : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        schoolInfoTblView.register(UINib.init(nibName: "CustomInformationTVC", bundle: nil), forCellReuseIdentifier: "CustomInformationTVC")
        socialTblView.register(UINib.init(nibName: "SocialMediaTVC", bundle: nil), forCellReuseIdentifier: "SocialMediaTVC")
        playerTblView.register(UINib.init(nibName: "CustomCoachInfoTVC", bundle: nil), forCellReuseIdentifier: "CustomCoachInfoTVC")
        followBtn.isSelected = isFollow
        serviceCallToGetCollageDetail()
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectMenu(_ sender: UIButton) {
        collegeInfoBtn.isSelected = false
        coachBtn.isSelected = false
        collegeLbl.isHighlighted = false
        coachLbl.isHighlighted = false
        
        if sender == collegeInfoBtn {
            coachInfoBackView.removeFromSuperview()
            selectMenu(btn: collegeInfoBtn, lbl: collegeLbl)
            setCollegeInfoView()
        }
        else if sender == coachBtn {
            collegeInfoBackView.removeFromSuperview()
            selectMenu(btn: coachBtn, lbl: coachLbl)
            setCoachInfoView()
        }
    }
    
    @IBAction func clickToFavorite(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        serviceCallToAddToFavorite()
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == socialTblView {
            return arrSocialInfo.count
        } else if tableView == schoolInfoTblView {
            return arrSchoolInfo.count
        }
        else if tableView == playerTblView {
            return arrCoachInfo.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == socialTblView {
            let cell = socialTblView.dequeueReusableCell(withIdentifier: "SocialMediaTVC", for: indexPath) as! SocialMediaTVC
            let dict = arrSocialInfo[indexPath.row]
            cell.socialLbl.text = dict["title"]
            cell.imgBtn.setImage(UIImage(named: dict["image"]!), for: .normal)
            socialTblViewHeightConstraint.constant = socialTblView.contentSize.height
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == schoolInfoTblView {
            let cell = schoolInfoTblView.dequeueReusableCell(withIdentifier: "CustomInformationTVC", for: indexPath) as! CustomInformationTVC
            let dict = arrSchoolInfo[indexPath.row]
            cell.queLbl.text = dict["title"]
            cell.ansLbl.text = dict["value"]
            if dict["title"] == "Website" || dict["title"] == "Tournament Wins & Results"
            {
                if let strUrl : String = dict["value"]
                {
                    let Url : URL = URL(string: strUrl)!
                    if UIApplication.shared.canOpenURL(Url)
                    {
                        cell.ansLbl.textColorTypeAdapter = 8
                    }
                    else{
                        cell.ansLbl.textColorTypeAdapter = 3
                    }
                }else{
                    cell.ansLbl.textColorTypeAdapter = 3
                }
            }
            else
            {
                cell.ansLbl.textColorTypeAdapter = 3
            }
            schoolInfoTblViewHeightConstraint.constant = schoolInfoTblView.contentSize.height
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell : CustomCoachInfoTVC = playerTblView.dequeueReusableCell(withIdentifier: "CustomCoachInfoTVC", for: indexPath) as! CustomCoachInfoTVC
            let dict = arrCoachInfo[indexPath.row]
            setButtonBackgroundImage(dict.profile_image, btn: [cell.profilePicBtn])
            cell.nameLbl.text = dict.name
            cell.positionLbl.text = dict.position
            cell.phoneLbl.text = dict.phone
            cell.deskPhoneLbl.text = dict.desk_phone
            cell.emailLbl.text = dict.email_address
            cell.bioLbl.text = dict.bio
            playerTblViewHeightConstraint.constant = playerTblView.contentSize.height
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == socialTblView {
            let dict = arrSocialInfo[indexPath.row]
            if let strUrl : String = dict["value"]
            {
                openUrlInSafari(strUrl: strUrl)
            }
        }
        else if tableView == schoolInfoTblView {
            let dict = arrSchoolInfo[indexPath.row]
            if dict["title"] == "Website"
            {
                if let strUrl : String = dict["value"]
                {
                    openUrlInSafari(strUrl: strUrl)
                }
            }
            else if dict["title"] == "Tournament Wins & Results"
            {
                if let strUrl : String = dict["value"]
                {
                    openUrlInSafari(strUrl: strUrl)
                    /*
                    let Url : URL = URL(string: strUrl)!
                    if UIApplication.shared.canOpenURL(Url)
                    {
                        let vc : AppWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "AppWebViewVC") as! AppWebViewVC
                        vc.strUrl = strUrl
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    */
                }
            }
        }
    }
    
    func selectMenu(btn : UIButton, lbl : UILabel)
    {
        btn.isSelected = true
        lbl.isHighlighted = true
    }
    
    func serviceCallToGetCollageDetail()
    {
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["college_id"] = college_id
        APIManager.shared.serviceCallToGetCollageDetail(param) { (data) in
            if let mainData : [String : Any] = data["main"] as? [String : Any]
            {
                self.collageMainData = CollageMainModel.init(dict: mainData)
            }
            if let college_info : [String : Any] = data["college_info"] as? [String : Any]
            {
                self.collageInfoData = CollageInfoModel.init(dict: college_info)
            }
            if let coach_info : [[String : Any]] = data["coach_info"] as? [[String : Any]]
            {
                for temp in coach_info
                {
                    self.arrCoachInfo.append(CoachInfoModel.init(dict: temp))
                }
            }
            self.setCollageData()
        }
    }
    
    func setCollageData()
    {
        setButtonBackgroundImage(collageMainData.profile_image, btn: [collagePicBtn])
        collageNameLbl.text = collageMainData.name
        collageStateLbl.text = collageMainData.state + "\n" + collageMainData.devision
        clickToSelectMenu(collegeInfoBtn)
    }
    
    func setCollegeInfoView() {
        
        collageTypeLbl.text = collageInfoData.type_of_college
        
        arrSchoolInfo = [[String : String]]()
        var tempDict : [String : String] = [String : String]()
        if collageInfoData.website != "" {
            tempDict["title"] = "Website"
            tempDict["value"] = collageInfoData.website
            arrSchoolInfo.append(tempDict)
        }
        
        if collageInfoData.city != "" {
            tempDict = [String : String]()
            tempDict["title"] = "City"
            tempDict["value"] = collageInfoData.city
            arrSchoolInfo.append(tempDict)
        }
        
        if collageInfoData.region != "" {
            tempDict = [String : String]()
            tempDict["title"] = "Region"
            tempDict["value"] = collageInfoData.region
            arrSchoolInfo.append(tempDict)
        }
        
        if collageInfoData.college_conference != "" {
            tempDict = [String : String]()
            tempDict["title"] = "College Conference"
            tempDict["value"] = collageInfoData.college_conference
            arrSchoolInfo.append(tempDict)
        }
        
        if collageInfoData.tournament_wins != "" {
            tempDict = [String : String]()
            tempDict["title"] = "Tournament Wins & Results"
            tempDict["value"] = collageInfoData.tournament_wins
            arrSchoolInfo.append(tempDict)
        }
        
        if collageInfoData.acceptance != "" {
            tempDict = [String : String]()
            tempDict["title"] = "Acceptance"
            tempDict["value"] = collageInfoData.acceptance
            arrSchoolInfo.append(tempDict)
        }
        
        if collageInfoData.local_population != "" {
            tempDict = [String : String]()
            tempDict["title"] = "Local Population"
            tempDict["value"] = collageInfoData.local_population
            arrSchoolInfo.append(tempDict)
        }
        schoolInfoTblView.reloadData()
        
        
        arrSocialInfo = [[String : String]]()
        if collageInfoData.facebook_link != "" {
            tempDict = [String : String]()
            tempDict["title"] = "Facebook"
            tempDict["value"] = collageInfoData.facebook_link
            tempDict["image"] = "facebook"
            arrSocialInfo.append(tempDict)
        }
        if collageInfoData.twitter_link != "" {
            tempDict = [String : String]()
            tempDict["title"] = "Twitter"
            tempDict["value"] = collageInfoData.twitter_link
            tempDict["image"] = "twitter"
            arrSocialInfo.append(tempDict)
        }
        if collageInfoData.instagram_link != "" {
            tempDict = [String : String]()
            tempDict["title"] = "Instagram"
            tempDict["value"] = collageInfoData.instagram_link
            tempDict["image"] = "instagram"
            arrSocialInfo.append(tempDict)
        }
        socialTblView.reloadData()
        setCollageInfoHeight()
        displaySubViewtoParentView(containerView, subview: collegeInfoBackView)
        delay(1.0) {
            self.setCollageInfoHeight()
        }
    }
    
    func setCollageInfoHeight()
    {
        schoolInfoTblViewHeightConstraint.constant = schoolInfoTblView.contentSize.height
        socialTblViewHeightConstraint.constant = socialTblView.contentSize.height
        ContainerViewHeightConstraint.constant = 200 + schoolInfoTblViewHeightConstraint.constant + socialTblViewHeightConstraint.constant
    }
    
    func setCoachInfoView() {
        playerTblView.reloadData()
        setCoachInfoViewHeight()
        displaySubViewtoParentView(containerView, subview: coachInfoBackView)
        delay(1.0) {
            self.setCoachInfoViewHeight()
        }
    }
    
    func setCoachInfoViewHeight() {
        if arrCoachInfo.count > 0 {
            playerTblViewHeightConstraint.constant = playerTblView.contentSize.height
            ContainerViewHeightConstraint.constant = 20 + playerTblViewHeightConstraint.constant
        }
        else
        {
            ContainerViewHeightConstraint.constant = 0
        }
        
    }
    
    func serviceCallToAddToFavorite()
    {
        var params : [String : Any] = [String : Any]()
        params["user_id"] = AppModel.shared.currentUser.uId
        params["college_id"] = college_id
        params["value"] = followBtn.isSelected ? "yes" : "no"
        APIManager.shared.serviceCallToAddFavoriteCollage(params) { (data) in
            var tempDict : [String : String] = [String : String]()
            tempDict["college_id"] = self.college_id
            tempDict["favorite"] = self.followBtn.isSelected ? "yes" : "no"
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_FAVORITE_STATUS), object: tempDict)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
