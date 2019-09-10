//
//  CoachCollegeDashboardVC.swift
//  SandRecruits
//
//  Created by PC on 02/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CoachCollegeDashboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout, AtheletTrackingDelegate {

    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var divisionLbl: Label!
    @IBOutlet weak var roleLbl: Label!
    @IBOutlet var followedCollectionView: UICollectionView!
    
    @IBOutlet weak var searchAthleteTxt: TextField!
    @IBOutlet weak var searchFollowerTxt: TextField!
    @IBOutlet var athleteTblView: UITableView!
    @IBOutlet var athleteTblViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var followingUserDetailBackView: UIView!
    @IBOutlet var followingUserTblView: UITableView!
    
    var collageData : CollageModel = CollageModel.init()
    var followArr : [PlayerMainModel] = [PlayerMainModel]()
    var searchFollowArr : [PlayerMainModel] = [PlayerMainModel]()
    var trackedArr : [PlayerMainModel] = [PlayerMainModel]()
    var searchTrackedArr : [PlayerMainModel] = [PlayerMainModel]()
    var coachesData : CoachesModel = CoachesModel.init()
    
    var selectedExpandId : String = ""
    var selectedAddEditId : String = ""
    var selectedAddEditNoteId : String = ""
    var followDisplayCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        athleteTblView.register(UINib(nibName: "AtheletTrackingTVC", bundle: nil), forCellReuseIdentifier: "AtheletTrackingTVC")
        followingUserTblView.register(UINib(nibName: "FollowedTVC", bundle: nil), forCellReuseIdentifier: "FollowedTVC")
        followedCollectionView.register(UINib(nibName: "FollowedCVC", bundle: nil), forCellWithReuseIdentifier: "FollowedCVC")
        
        searchAthleteTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        searchFollowerTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        followingUserDetailBackView.isHidden = true
        displaySubViewtoParentView(self.view, subview: followingUserDetailBackView)
        
        getCoachDashboardData()
    }

    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.menuContainerViewController.toggleRightSideMenuCompletion {
            
        }
    }
    @IBAction func clickToFollowedViewBack(_ sender: Any) {
        self.view.endEditing(true)
        followingUserDetailBackView.isHidden = true
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == athleteTblView {
            return ((searchAthleteTxt.text?.trimmed != "") ? searchTrackedArr.count : trackedArr.count)
        }
        else {
            return ((searchFollowerTxt.text?.trimmed != "") ? searchFollowArr.count : followArr.count)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == athleteTblView {
            let cell = athleteTblView.dequeueReusableCell(withIdentifier: "AtheletTrackingTVC", for: indexPath) as! AtheletTrackingTVC
            
            cell.delegate = self
            let dict : PlayerMainModel = (searchAthleteTxt.text?.trimmed != "") ? searchTrackedArr[indexPath.row] : trackedArr[indexPath.row]
            cell.player = dict
            setButtonBackgroundImage(dict.profile_image, btn: [cell.imgBtn])
            cell.nameLbl.text = dict.name
            cell.srLbl.text = "SR#:" + dict.sr
            cell.yearLbl.text = "Grad Year: " + dict.grandyear
            cell.locationLbl.text = dict.location
            if dict.tracked_by.count > 0
            {
                cell.trackedLbl.text = "Tracked by " + dict.tracked_by.joined(separator: ", ")
            }
            else
            {
                cell.trackedLbl.text = ""
            }
            cell.expandBtn.tag = indexPath.row
            cell.expandBtn.addTarget(self, action: #selector(clickToExpand(_:)), for: .touchUpInside)
            
            cell.addNoteBtn.tag = indexPath.row
            cell.addNoteBtn.addTarget(self, action: #selector(clickToAddEditNote(_:)), for: .touchUpInside)
            cell.editNoteBtn.tag = indexPath.row
            cell.editNoteBtn.addTarget(self, action: #selector(clickToAddEditNote(_:)), for: .touchUpInside)
            
            cell.editView.isHidden = true
            cell.addSaveView.isHidden = true
            cell.editBtnView.isHidden = true
            cell.addBtnView.isHidden = true
            cell.constraintHeightEditView.constant = 0
            cell.constraintHeightAddSaveView.constant = 0
            
            cell.noteLbl.text = dict.note
            cell.expandBtn.isSelected = (selectedExpandId == dict.id)
            if selectedExpandId == dict.id {
                cell.addSaveView.isHidden = false
                if dict.note == ""
                {
                    cell.addBtnView.isHidden = false
                    cell.constraintHeightAddSaveView.constant = 55
                }
                else
                {
                    cell.constraintHeightAddSaveView.constant = cell.noteLbl.requiredHeight + 60
                    cell.editBtnView.isHidden = false
                }
            }
            else if selectedAddEditNoteId == dict.id
            {
                cell.editView.isHidden = false
                cell.constraintHeightEditView.constant = 110
            }
            
            cell.removeBtn.tag = indexPath.row
            cell.removeBtn.addTarget(self, action: #selector(clickToRemove(_:)), for: .touchUpInside)
            
            athleteTblViewHeightConstraint.constant = athleteTblView.contentSize.height
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = followingUserTblView.dequeueReusableCell(withIdentifier: "FollowedTVC", for: indexPath) as! FollowedTVC
            let dict = (searchFollowerTxt.text?.trimmed != "") ? searchFollowArr[indexPath.row] : followArr[indexPath.row]
            setButtonBackgroundImage(dict.profile_image, btn: [cell.profileImgBtn])
            cell.nameLbl.text = dict.name
            cell.srLbl.text = "SR#: " + dict.sr
            cell.yearLbl.text = "Grand Year: " + dict.grandyear
            cell.addressLbl.text = dict.location
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : OtherUserProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
        if tableView == athleteTblView {
            let dict : PlayerMainModel = (searchAthleteTxt.text?.trimmed != "") ? searchTrackedArr[indexPath.row] : trackedArr[indexPath.row]
            vc.player_id = dict.id
        }
        else
        {
            let dict = (searchFollowerTxt.text?.trimmed != "") ? searchFollowArr[indexPath.row] : followArr[indexPath.row]
            vc.player_id = dict.id
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToRemove(_ sender: UIButton) {
        let dict : PlayerMainModel = (searchAthleteTxt.text?.trimmed != "") ? searchTrackedArr[sender.tag] : trackedArr[sender.tag]
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["player_id"] = dict.id
        param["value"] = "no"
        
        APIManager.shared.serviceCallToTrackPlayer(param) { (data) in
            
            let index = self.trackedArr.firstIndex(where: { (temp) -> Bool in
                temp.id == dict.id
            })
            
            if index != nil
            {
                self.trackedArr.remove(at: index!)
                if self.searchAthleteTxt.text?.trimmed != ""
                {
                    let index1 = self.searchTrackedArr.firstIndex(where: { (temp) -> Bool in
                        temp.id == dict.id
                    })
                    
                    if index1 != nil
                    {
                        self.searchTrackedArr.remove(at: index1!)
                    }
                }
                self.athleteTblView.reloadData()
                delay(0.5) {
                    self.athleteTblViewHeightConstraint.constant = self.athleteTblView.contentSize.height
                }
            }
        }
    }
    
    @IBAction func clickToExpand(_ sender: UIButton) {
        let dict : PlayerMainModel = (searchAthleteTxt.text?.trimmed != "") ? searchTrackedArr[sender.tag] : trackedArr[sender.tag]
        if selectedExpandId == dict.id
        {
            selectedExpandId = ""
        }
        else
        {
            selectedExpandId = dict.id
        }
        selectedAddEditNoteId = ""
        athleteTblView.reloadData()
        delay(0.5) {
            self.athleteTblViewHeightConstraint.constant = self.athleteTblView.contentSize.height
        }
    }
    
    @IBAction func clickToAddEditNote(_ sender: UIButton) {
        let dict : PlayerMainModel = (searchAthleteTxt.text?.trimmed != "") ? searchTrackedArr[sender.tag] : trackedArr[sender.tag]
        if selectedAddEditNoteId == dict.id
        {
            selectedAddEditNoteId = ""
        }
        else
        {
            selectedAddEditNoteId = dict.id
        }
        selectedExpandId = ""
        athleteTblView.reloadData()
        delay(0.5) {
            self.athleteTblViewHeightConstraint.constant = self.athleteTblView.contentSize.height
        }
    }
    
    func updateNoteText(note: String, player: PlayerMainModel) {
        self.view.endEditing(true)
        serviceCallToSaveNote(note: note, player_id: player.id)
    }
    
    //MARK: - CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followDisplayCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = followedCollectionView.dequeueReusableCell(withReuseIdentifier: "FollowedCVC", for: indexPath) as! FollowedCVC
        
        if indexPath.row == followDisplayCount - 1 {
            cell.countLbl.isHidden = false
            cell.countLbl.text = "+" + String(followArr.count - followDisplayCount + 1)
        }
        else {
            cell.countLbl.isHidden = true
        }
        
        setButtonBackgroundImage(followArr[indexPath.row].profile_image, btn: [cell.imgBtn])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        followingUserDetailBackView.isHidden = false
        followingUserTblView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let Height = followedCollectionView.frame.size.height
        let Width = Height
        return CGSize(width: Width, height: Height)
    }
    
    func getCoachDashboardData()
    {
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["college_id"] = AppModel.shared.currentUser.collegeID
        
        APIManager.shared.serviceCallToGetCollageDetail(param) { (data) in
            if let main : [String : Any] = data["main"] as? [String : Any]
            {
                self.collageData = CollageModel.init(dict: main)
            }
            if let coaches : [String : Any] = data["coaches"] as? [String : Any]
            {
                self.coachesData = CoachesModel.init(dict: coaches)
            }
            if let followed : [[String : Any]] = data["followed"] as? [[String : Any]]
            {
                for temp in followed
                {
                    self.followArr.append(PlayerMainModel.init(dict: temp))
                }
            }
            if let tracked : [[String : Any]] = data["tracked"] as? [[String : Any]]
            {
                for temp in tracked
                {
                    self.trackedArr.append(PlayerMainModel.init(dict: temp))
                }
            }
            self.setCollageData()
        }
    }
    
    func setCollageData()
    {
        setButtonBackgroundImage(collageData.profile_image, btn: [profilePicBtn])
        nameLbl.text = collageData.name
        divisionLbl.text = collageData.devision
        roleLbl.text = ""
        if coachesData.head_coach.count > 0
        {
            for temp in coachesData.head_coach
            {
                if roleLbl.text == ""
                {
                    roleLbl.text = temp + " (Head Coach)"
                }
                else
                {
                    roleLbl.text = roleLbl.text! + "\n" + temp + " (Head Coach)"
                }
                
            }
        }
        if coachesData.assistant_coach.count > 0
        {
            for temp in coachesData.assistant_coach
            {
                if roleLbl.text == ""
                {
                    roleLbl.text = temp + " (Assistant Coach)"
                }
                else
                {
                    roleLbl.text = roleLbl.text! + "\n" + temp + " (Assistant Coach)"
                }
                
            }
        }
        if coachesData.other_coach.count > 0
        {
            for temp in coachesData.other_coach
            {
                if roleLbl.text == ""
                {
                    roleLbl.text = temp + " (Other Coach)"
                }
                else
                {
                    roleLbl.text = roleLbl.text! + "\n" + temp + " (Other Coach)"
                }
            }
        }
        
        let cellWH = followedCollectionView.frame.size.height
        let displayCell : Int = Int(followedCollectionView.frame.size.width/cellWH)
        if displayCell < followArr.count
        {
            followDisplayCount = displayCell
        }
        else
        {
            followDisplayCount = followArr.count
        }
        
        followedCollectionView.reloadData()
        
        athleteTblView.reloadData()
        athleteTblViewHeightConstraint.constant = athleteTblView.contentSize.height
    }
    
    func serviceCallToSaveNote(note : String, player_id : String)
    {
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["player_id"] = player_id
        param["note"] = note
        
        APIManager.shared.serviceCallToSaveNote(param) { (data) in
            
            let index = self.trackedArr.firstIndex { (temp) -> Bool in
                temp.id == player_id
            }
            if index != nil
            {
                let index1 = self.searchTrackedArr.firstIndex { (temp) -> Bool in
                    temp.id == player_id
                }
                if index1 != nil
                {
                    self.searchTrackedArr[index1!].note = note
                }
                self.trackedArr[index!].note = note
                self.selectedAddEditNoteId = ""
                self.selectedExpandId = self.trackedArr[index!].id
                self.athleteTblView.reloadData()
                delay(0.5) {
                    self.athleteTblViewHeightConstraint.constant = self.athleteTblView.contentSize.height
                }
            }
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
     
        if textField == searchAthleteTxt {
            searchTrackedArr = [PlayerMainModel]()
            
            searchTrackedArr = trackedArr.filter({ (temp) -> Bool in
                let nameTxt: NSString = temp.name! as NSString
                let srTxt: NSString = temp.sr! as NSString
                let gradYearTxt: NSString = temp.grandyear! as NSString
                
                return ((nameTxt.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound || (srTxt.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound || (gradYearTxt.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound)
            })
            athleteTblView.reloadData()
            delay(0.5) {
                self.athleteTblViewHeightConstraint.constant = self.athleteTblView.contentSize.height
            }
            
        }
        else if textField == searchFollowerTxt {
            searchFollowArr = [PlayerMainModel]()
            
            searchFollowArr = followArr.filter({ (temp) -> Bool in
                let nameTxt: NSString = temp.name! as NSString
                let srTxt: NSString = temp.sr! as NSString
                
                return ((nameTxt.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound || (srTxt.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound)
            })
            followingUserTblView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
