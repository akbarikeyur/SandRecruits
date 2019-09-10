//
//  CoachAthleteSearchVC.swift
//  SandRecruits
//
//  Created by PC on 03/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CoachAthleteSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource , UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet var filterMainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var applyFilterBtn: UIButton!
    @IBOutlet var applyFilterSearchBackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var applyFilterSearchBackView: UIView!
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchAthletTxt: TextField!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var athletePicker: UIPickerView!
    @IBOutlet weak var graduationTxt: TextField!
    @IBOutlet weak var educationTxt: TextField!
    @IBOutlet weak var stateTxt: TextField!
    @IBOutlet weak var travelTxt: TextField!
    @IBOutlet weak var gpaTxt: TextField!
    @IBOutlet weak var positionTxt: TextField!
    
    @IBOutlet weak var totalAthletLbl: Label!
    @IBOutlet weak var viewTrackBtn: UIButton!
    @IBOutlet weak var hideCommitBtn: UIButton!
    
    var arrPlayerData : [PlayerMainModel] = [PlayerMainModel]()
    
    var arr : [ValueModel] = [ValueModel]()
    var filterDict : [String : Any] = [String : Any]()
    var arrGrandyear : [ValueModel] = [ValueModel]()
    var arrCurrentEducationLevel : [ValueModel] = [ValueModel]()
    var arrState : [ValueModel] = [ValueModel]()
    var arrTravel : [ValueModel] = [ValueModel]()
    var arrGPA : [ValueModel] = [ValueModel]()
    var arrPosition : [ValueModel] = [ValueModel]()
    var page = 1
    var limit = 10
    var isLoadNextData : Bool = true
    var type = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateTrackStatus(noti:)), name: NSNotification.Name.init(NOTIFICATION.UPDATE_TRACK_STATUS), object: nil)
        
        tblView.register(UINib(nibName: "CoachAthleteSearchTVC", bundle: nil), forCellReuseIdentifier: "CoachAthleteSearchTVC")
        
        AppDesign()
        resetAllData()
        getfilterDict()
        refreshData()
    }
    
    @objc func updateTrackStatus(noti : Notification)
    {
        if let dict : [String : Any] = noti.object as? [String : Any]
        {
            let tempPlayer : PlayerMainModel = PlayerMainModel.init(dict: dict)
            let index = arrPlayerData.firstIndex { (temp) -> Bool in
                temp.id == tempPlayer.id
            }
            if index != nil
            {
                arrPlayerData[index!].track_player = tempPlayer.track_player
                tblView.reloadData()
            }
        }
    }
    
    func AppDesign()  {
        applyFilterBtn.isSelected = false
        applyFilterSearchBackView.isHidden = true
        applyFilterSearchBackViewHeightConstraint.constant = 0
        filterMainViewHeightConstraint.constant = 108
        
    }
    
    func refreshData()
    {
        page = 1
        limit = 100
        isLoadNextData = true
        getPlayerList()
    }
    
    func resetAllData()
    {
        filterDict = [String : Any]()
        filterDict["grandyear"] = ""
        filterDict["currenteducationlevel"] = ""
        filterDict["state"] = ""
        filterDict["willing_travel"] = ""
        filterDict["gpa"] = ""
        filterDict["position"] = ""
        filterDict["tracked"] = "0"
        filterDict["committed"] = "0"
        
        searchAthletTxt.text = ""
        graduationTxt.text = ""
        educationTxt.text = ""
        stateTxt.text = ""
        travelTxt.text = ""
        gpaTxt.text = ""
        positionTxt.text = ""
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
    
    @IBAction func clicKToApplyFilter(_ sender: Any) {
        if applyFilterBtn.isSelected == true {
            applyFilterBtn.isSelected = false
            applyFilterSearchBackView.isHidden = true
            applyFilterSearchBackViewHeightConstraint.constant = 0
            filterMainViewHeightConstraint.constant = 108
        }
        else {
            applyFilterBtn.isSelected = true
            applyFilterSearchBackView.isHidden = false
            applyFilterSearchBackViewHeightConstraint.constant = 606
            filterMainViewHeightConstraint.constant = 714
        }
    }
    
    @IBAction func clickToSelectPicker(_ sender: UIButton) {
        self.view.endEditing(true)
        arr = [ValueModel]()
        type = sender.tag
        switch type {
            case 1:
                arr = arrGrandyear
                break
            case 2:
                arr = arrCurrentEducationLevel
                break
            case 3:
                arr = arrState
                break
            case 4:
                arr = arrTravel
                break
            case 5:
                arr = arrGPA
                break
            case 6:
                arr = arrPosition
                break
            default:
                break
        }
        athletePicker.reloadAllComponents()
        pickerView.isHidden = false
    }
    
    @IBAction func clickToDone(_ sender: Any) {
        pickerView.isHidden = true
    }
    
    @IBAction func clickToApplyFilter(_ sender: Any) {
        clicKToApplyFilter(applyFilterBtn)
        refreshData()
    }
    
    @IBAction func clickToResetFilter(_ sender: Any) {
        clicKToApplyFilter(applyFilterBtn)
        resetAllData()
        refreshData()
    }
    
    @IBAction func clickToSearch(_ sender: Any) {
        self.view.endEditing(true)
        refreshData()
    }
    
    //MARK; - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlayerData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "CoachAthleteSearchTVC", for: indexPath) as! CoachAthleteSearchTVC
        
        let dict = arrPlayerData[indexPath.row]
        setButtonBackgroundImage(dict.profile_image, btn: [cell.profileImgBtn])
        cell.nameLbl.text = dict.name
        cell.srLbl.text = "SR#: " + dict.sr
        cell.addressLbl.text = dict.location
        cell.yearLbl.text = dict.grandyear
        cell.trackBtn.isSelected = (dict.track_player.lowercased() == "yes")
        cell.trackBtn.tag = indexPath.row
        cell.trackBtn.addTarget(self, action: #selector(clickToTrackPlayer(sender:)), for: .touchUpInside)
        
        tblViewHeightConstraint.constant = tblView.contentSize.height
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : OtherUserProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
        vc.player_id = arrPlayerData[indexPath.row].id
        vc.track_player = arrPlayerData[indexPath.row].track_player.lowercased()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (arrPlayerData.count - 1) && isLoadNextData
        {
            print(arrPlayerData.count)
//            getPlayerList()
        }
    }
    
    @objc func clickToTrackPlayer(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        arrPlayerData[sender.tag].track_player = (sender.isSelected ? "yes" : "no")
        let dict = arrPlayerData[sender.tag]
        serviceCallToTrackPlayer(player_id: dict.id, value: (sender.isSelected ? "yes" : "no"))
    }
    
    @IBAction func clickToViewTrackCheckbox(sender : UIButton) {
        sender.isSelected = sender.isSelected == true ? false : true
        filterDict["tracked"] = (sender.isSelected) ? "1" : "0"
        getPlayerList()
    }
    
    @IBAction func clickToHideCommitedPlayerCheckbox(sender : UIButton) {
        sender.isSelected = sender.isSelected == true ? false : true
        filterDict["committed"] = (sender.isSelected) ? "1" : "0"
        getPlayerList()
    }
    
    //MARK: - PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch type {
            case 1:
                graduationTxt.text = arrGrandyear[row].label
                filterDict["grandyear"] = arrGrandyear[row].value
                break
            case 2:
                educationTxt.text = arrCurrentEducationLevel[row].label
                filterDict["currenteducationlevel"] = arrCurrentEducationLevel[row].value
                break
            case 3:
                stateTxt.text = arrState[row].label
                filterDict["state"] = arrState[row].value
                break
            case 4:
                travelTxt.text = arrTravel[row].label
                filterDict["willing_travel"] = arrTravel[row].value
                break
            case 5:
                gpaTxt.text = arrGPA[row].label
                filterDict["gpa"] = arrGPA[row].value
                break
            case 6:
                positionTxt.text = arrPosition[row].label
                filterDict["position"] = arrPosition[row].value
                break
            default:
                    break
        }
    }
    
    func getfilterDict()
    {
        APIManager.shared.serviceCallToGetPlayerFilter { (data) in
            if let temp : [[String : Any]] = data["grandyear"] as? [[String : Any]]
            {
                for tempDict in temp
                {
                    self.arrGrandyear.append(ValueModel.init(dict: tempDict))
                }
            }
            if let temp : [[String : Any]] = data["currenteducationlevel"] as? [[String : Any]]
            {
                for tempDict in temp
                {
                    self.arrCurrentEducationLevel.append(ValueModel.init(dict: tempDict))
                }
            }
            if let temp : [[String : Any]] = data["state"] as? [[String : Any]]
            {
                for tempDict in temp
                {
                    self.arrState.append(ValueModel.init(dict: tempDict))
                }
            }
            if let temp : [[String : Any]] = data["willing_travel"] as? [[String : Any]]
            {
                for tempDict in temp
                {
                    self.arrTravel.append(ValueModel.init(dict: tempDict))
                }
            }
            if let temp : [[String : Any]] = data["gpa"] as? [[String : Any]]
            {
                for tempDict in temp
                {
                    self.arrGPA.append(ValueModel.init(dict: tempDict))
                }
            }
            if let temp : [[String : Any]] = data["position"] as? [[String : Any]]
            {
                for tempDict in temp
                {
                    self.arrPosition.append(ValueModel.init(dict: tempDict))
                }
            }
        }
    }
    
    func getPlayerList()
    {
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["page_no"] = page
        param["limit"] = limit
        param["sp"] = searchAthletTxt.text
        param["grandyear"] = filterDict["grandyear"]
        param["currenteducationlevel"] = filterDict["currenteducationlevel"]
        param["state"] = filterDict["state"]
        param["willing_travel"] = filterDict["willing_travel"]
        param["gpa"] = filterDict["gpa"]
        param["position"] = filterDict["position"]
        param["tracked"] = filterDict["tracked"]
        param["committed"] = filterDict["committed"]
        print(param)
        APIManager.shared.serviceCallToGetPlayerList(param) { (data, total_count)  in
            self.totalAthletLbl.text = total_count + " Athletes"
            self.arrPlayerData = [PlayerMainModel]()
            for temp in data
            {
                self.arrPlayerData.append(PlayerMainModel.init(dict: temp))
            }
            DispatchQueue.main.async {
                self.tblView.reloadData()
                self.tblViewHeightConstraint.constant = self.tblView.contentSize.height
            }
            if data.count < self.limit
            {
                self.isLoadNextData = false
            }
            else
            {
                self.page = self.page + 1
            }
        }
    }
    
    func serviceCallToTrackPlayer(player_id : String, value : String)
    {
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["player_id"] = player_id
        param["value"] = value
        
        APIManager.shared.serviceCallToTrackPlayer(param) { (data) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
