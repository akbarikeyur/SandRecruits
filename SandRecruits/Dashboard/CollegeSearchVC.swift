//
//  CollegeSearchVC.swift
//  SandRecruits
//
//  Created by PC on 29/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CollegeSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource , UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var searchTxt: TextField!
    @IBOutlet var stateTxt: TextField!
    @IBOutlet var regionTxt: TextField!
    @IBOutlet var scholarShipTxt: TextField!
    @IBOutlet var divisionTxt: TextField!
    @IBOutlet var conferenceTxt: TextField!
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var pickerBackView: UIView!
    
    @IBOutlet weak var totalCollegeLbl: Label!
    @IBOutlet var showFollowBtn: UIButton!
    
    var arrCollageList : [CollageModel] = [CollageModel]()
    
    var arr : [ValueModel] = [ValueModel]()
    var stateArr : [ValueModel] = [ValueModel]()
    var regionArr : [ValueModel] = [ValueModel]()
    var scholarShipArr : [ValueModel] = [ValueModel]()
    var divisionArr : [ValueModel] = [ValueModel]()
    var conferenceArr : [ValueModel] = [ValueModel]()
    var type : Int = 1
    var page = 1
    var limit = 10
    var filterDict : [String : Any] = [String : Any]()
    var isFavorite : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteStatus(noti:)), name: NSNotification.Name.init(NOTIFICATION.UPDATE_FAVORITE_STATUS), object: nil)
        
       tblView.register(UINib(nibName: "CollageSearchTVC", bundle: nil), forCellReuseIdentifier: "CollageSearchTVC")
        pickerBackView.isHidden = true
        
        resetFilterData()
        getCollageFilter()
    }
    
    func resetFilterData()
    {
        page = 1
        limit = -1
        searchTxt.text = ""
        filterDict["state"] = ""
        filterDict["region"] = ""
        filterDict["scholarship"] = ""
        filterDict["division"] = ""
        filterDict["conference"] = ""
        searchTxt.text = ""
        stateTxt.text = ""
        scholarShipTxt.text = ""
        divisionTxt.text = ""
        conferenceTxt.text = ""
    }
    
    @objc func updateFavoriteStatus(noti : Notification)
    {
        if let dict : [String : Any] = noti.object as? [String : Any]
        {
            if let collage_id : String = dict["college_id"] as? String
            {
                let index = arrCollageList.firstIndex { (temp) -> Bool in
                    temp.id == collage_id
                }
                if index != nil
                {
                    if let favorite : String = dict["favorite"] as? String
                    {
                        arrCollageList[index!].favorite = favorite
                        tblView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelection(_ sender: UIButton) {
        self.view.endEditing(true)
        type = sender.tag
        
        switch type {
            case 1:
                arr = stateArr
                break
            case 2:
                arr = regionArr
                break
            case 3:
                arr = scholarShipArr
                break
            case 4:
                arr = divisionArr
                break
            case 5:
                arr = conferenceArr
                break
            default:
                break
        }
        pickerView.reloadAllComponents()
        pickerBackView.isHidden = false
    }
    
    @IBAction func clickToSearch(_ sender: Any) {
        self.view.endEditing(true)
        serviceCallToGetCollageList()
    }
    
    @IBAction func clickToPickerDone(_ sender: Any) {
        pickerBackView.isHidden = true
        serviceCallToGetCollageList()
    }
    
    @IBAction func clickToReset(_ sender: Any) {
        resetFilterData()
        serviceCallToGetCollageList()
    }
    
    //MARK; - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCollageList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "CollageSearchTVC", for: indexPath) as! CollageSearchTVC
        
        let dict = arrCollageList[indexPath.row]
        setButtonBackgroundImage(dict.profile_image, btn: [cell.imgBtn])
        cell.collegeNameLbl.text = dict.name
        cell.shortNameLbl.text = dict.devision
        
        if dict.city != ""
        {
            cell.addressLbl.text = dict.city
        }
        
        if cell.addressLbl.text == ""
        {
            cell.addressLbl.text = dict.state
        }
        else
        {
            cell.addressLbl.text = dict.city + ", " + dict.state
        }
        
        if dict.favorite.lowercased() == "no"
        {
            cell.proBtn.isSelected = false
        }
        else
        {
            cell.proBtn.isSelected = true
        }
        cell.proBtn.tag = indexPath.row
        cell.proBtn.addTarget(self, action: #selector(clickToFollow(sender:)), for: .touchUpInside)
        
        tblViewHeightConstraint.constant = tblView.contentSize.height
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomDetailVC") as! CustomDetailVC
        vc.college_id = arrCollageList[indexPath.row].id
        vc.isFollow = (arrCollageList[indexPath.row].favorite.lowercased() == "yes")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToShowFollow(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        isFavorite = sender.isSelected
        serviceCallToGetCollageList()
    }
    
    @IBAction func clickToFollow(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        serviceCallToAddToFavorite(college_id: arrCollageList[sender.tag].id, value: (sender.isSelected ? "yes" : "no"))
        arrCollageList[sender.tag].favorite = (sender.isSelected ? "yes" : "no")
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
        if type == 1 {
            stateTxt.text = stateArr[row].label
            filterDict["state"] = stateArr[row].value
        }
        else if type == 2 {
            regionTxt.text = regionArr[row].label
            filterDict["region"] = regionArr[row].value
        }
        else if type == 3 {
            scholarShipTxt.text = scholarShipArr[row].label
            filterDict["scholarship"] = scholarShipArr[row].value
        }
        else if type == 4 {
            divisionTxt.text = divisionArr[row].label
            filterDict["division"] = divisionArr[row].value
        }
        else if type == 5 {
            conferenceTxt.text = conferenceArr[row].label
            filterDict["conference"] = conferenceArr[row].value
        }
    }
    
    @objc func clickToCheckBox(sender : UIButton) {
        sender.isSelected = sender.isSelected == true ? false : true
        isFavorite = sender.isSelected
        serviceCallToGetCollageList()
    }

    func getCollageFilter()
    {
        APIManager.shared.serviceCallToGetCollageFilter { (data) in
            self.stateArr = [ValueModel]()
            if let state : [[String : Any]] = data["state"] as? [[String : Any]]
            {
                for temp in state
                {
                    self.stateArr.append(ValueModel.init(dict: temp))
                }
            }
            self.regionArr = [ValueModel]()
            if let region : [[String : Any]] = data["region"] as? [[String : Any]]
            {
                for temp in region
                {
                    self.regionArr.append(ValueModel.init(dict: temp))
                }
            }
            self.scholarShipArr = [ValueModel]()
            if let scholarship : [[String : Any]] = data["scholarship"] as? [[String : Any]]
            {
                for temp in scholarship
                {
                    self.scholarShipArr.append(ValueModel.init(dict: temp))
                }
            }
            self.divisionArr = [ValueModel]()
            if let division : [[String : Any]] = data["division"] as? [[String : Any]]
            {
                for temp in division
                {
                    self.divisionArr.append(ValueModel.init(dict: temp))
                }
            }
            self.conferenceArr = [ValueModel]()
            if let conference : [[String : Any]] = data["conference"] as? [[String : Any]]
            {
                for temp in conference
                {
                    self.conferenceArr.append(ValueModel.init(dict: temp))
                }
            }
            self.serviceCallToGetCollageList()
        }
    }
    
    func serviceCallToGetCollageList()
    {
        self.view.endEditing(true)
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
//        param["page_no"] = page
        param["limit"] = limit
        param["sd"] = searchTxt.text
        param["state"] = filterDict["state"]
        param["region"] = filterDict["region"]
        param["scholarship"] = filterDict["scholarship"]
        param["division"] = filterDict["division"]
        param["conference"] = filterDict["conference"]
        param["favorited"] = isFavorite ? 1 : 0
        print(param)
        APIManager.shared.serviceCallToGetCollageList(param) { (data, total) in
            self.totalCollegeLbl.text = total + " Colleges"
            if let collageData : [[String : Any]] = data["colleges"] as? [[String : Any]]
            {
                self.arrCollageList = [CollageModel]()
                for temp in collageData
                {
                    self.arrCollageList.append(CollageModel.init(dict: temp))
                }
                self.tblView.reloadData()
            }
        }
    }
    
    func serviceCallToAddToFavorite(college_id : String, value : String)
    {
        var params : [String : Any] = [String : Any]()
        params["user_id"] = AppModel.shared.currentUser.uId
        params["college_id"] = college_id
        params["value"] = value
        APIManager.shared.serviceCallToAddFavoriteCollage(params) { (data) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
