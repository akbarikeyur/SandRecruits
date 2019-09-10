//
//  CoachDashboardVC.swift
//  SandRecruits
//
//  Created by PC on 01/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CoachDashboardVC: UploadImageVC , UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, AtheletTrackingDelegate, UITextFieldDelegate {

    @IBOutlet var profileView: View!
    @IBOutlet var profileImgBtn: Button!
    @IBOutlet var nameLbl: Label!
    @IBOutlet weak var collegeNameLbl: Label!
    @IBOutlet weak var roleLbl: Label!
    @IBOutlet weak var deskPhoneLbl: Label!
    @IBOutlet var profileInfoBtn: Button!
    @IBOutlet var passwordResetBtn: Button!
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var pickerBackView: UIView!
    
    @IBOutlet var athleteTitleBackView: UIView!
    @IBOutlet var athleteTblView: UITableView!
    @IBOutlet var athleteTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var noteLbl: Label!
    
    @IBOutlet var profileEditView: UIView!
    @IBOutlet var selectedProfileImgBtn: Button!
    @IBOutlet var firstNameTxt: TextField!
    @IBOutlet var lastNameTxt: TextField!
    @IBOutlet var emailTxt: TextField!
    @IBOutlet var cellPhoneTxt: TextField!
    @IBOutlet var deskPhoneTxt: TextField!
    @IBOutlet var collegeAffiliationTxt: TextField!
    @IBOutlet var roleTxt: TextField!
    @IBOutlet var receiveEmailTxt: TextField!
    @IBOutlet var bioTextView: TextView!
    
    @IBOutlet weak var searchTxt: TextField!
    
    @IBOutlet var resetPasswordView: UIView!
    @IBOutlet var newPasswordTxt: TextField!
    @IBOutlet var resetPasswordTxt: TextField!
    
    var coachData : CoachModel = CoachModel.init()
    var coachSearchData : CoachModel = CoachModel.init()
    
    var arr : [String] = [String]()
    var collegeAffArr = ["Any State","Alabama","Arizona","Arkansas","California","Colarado"]
    var roleArr = ["Head Coach","Assistant Coach","Other"]
    var receiveEmailArr = ["Yes","No"]
    var type : Int = 1
    
    var selectedExpandId : String = ""
    var selectedAddEditId : String = ""
    var selectedAddEditNoteId : String = ""
    var isSearch : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        athleteTblView.register(UINib(nibName: "AtheletTrackingTVC", bundle: nil), forCellReuseIdentifier: "AtheletTrackingTVC")
    
        appDesign()
        serviceCallToGetCoachDetail()
    }
    
    func appDesign() {
        containerView.isHidden = true
        pickerBackView.isHidden = true
        noteLbl.isHidden = true
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

    @IBAction func clickToProfileOrPassword(_ sender: UIButton) {
        self.view.endEditing(true)
        
        print(Reset_Password)
        print(Edit_Coach_Profile)
        
        
        openUrlInSafari(strUrl: sender.tag == 1 ? Edit_Coach_Profile : Reset_Password)
        /*
        let vc : AppWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "AppWebViewVC") as! AppWebViewVC
        vc.strUrl = Edit_Coach_Profile
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    @IBAction func clickToChooseImage(_ sender: Any) {
        self.view.endEditing(true)
        uploadImage()
    }
    
    override func selectedImage(choosenImage: UIImage) {
        //selectedImageArr.append(choosenImage)
        selectedProfileImgBtn.setImage(choosenImage, for: .normal)
    }
    
    @IBAction func clickToselectFromPicker(_ sender: UIButton) {
        if sender.tag == 1 {
            type = 1
            arr = collegeAffArr
            pickerView.reloadAllComponents()
        }
        else if sender.tag == 2 {
            type = 2
            arr = roleArr
            pickerView.reloadAllComponents()
        }
        else if sender.tag == 3 {
            type = 3
            arr = receiveEmailArr
            pickerView.reloadAllComponents()
        }
        pickerBackView.isHidden = false
    }
    
    @IBAction func clickToPickerDone(_ sender: Any) {
        pickerBackView.isHidden = true
    }
    
    @IBAction func clickToSaveChanges(_ sender: Any) {
        
    }
    
    @IBAction func clickToChangePassword(_ sender: Any) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchText  = textField.text! + string
        
        if string  == "" {
            searchText = (searchText as String).substring(to: searchText.index(before: searchText.endIndex))
        }
        
        if searchText == "" {
            isSearch = false
            athleteTblView.reloadData()
        }
        else{
            
            coachSearchData.tracked = coachData.tracked.filter({ (result) -> Bool in
                
                let nameTxt: NSString = result.name! as NSString
                let srTxt: NSString = result.sr! as NSString
                let gradYearTxt: NSString = result.grandyear! as NSString
                
                return ((nameTxt.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound || (srTxt.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound || (gradYearTxt.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound)
                
             //   return (result.name.range(of: searchText) != nil)
            })
            
            isSearch = true
            athleteTblView.reloadData()
        }
        return true
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch == true ? coachSearchData.tracked.count : coachData.tracked.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = athleteTblView.dequeueReusableCell(withIdentifier: "AtheletTrackingTVC", for: indexPath) as! AtheletTrackingTVC
        cell.delegate = self
        let dict : PlayerMainModel = isSearch == true ? coachSearchData.tracked[indexPath.row] : coachData.tracked[indexPath.row]
        cell.player = dict
        setButtonBackgroundImage(dict.profile_image, btn: [cell.imgBtn])
        cell.nameLbl.text = dict.name
        cell.srLbl.text = "SR#:" + dict.sr
        cell.yearLbl.text = "Grad Year: " + dict.grandyear
        cell.locationLbl.text = dict.location
        cell.trackedLbl.text = ""
        
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(clickToRemove(_:)), for: .touchUpInside)
        
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
        cell.expandBtn.isSelected = (selectedExpandId == dict.id)
        athleteTblViewHeightConstraint.constant = athleteTblView.contentSize.height
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict : PlayerMainModel = coachData.tracked[indexPath.row]
        let vc : OtherUserProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
        vc.player_id = dict.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToRemove(_ sender: UIButton) {
        let dict : PlayerMainModel = coachData.tracked[sender.tag]
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["player_id"] = dict.id
        param["value"] = "no"
        
        APIManager.shared.serviceCallToTrackPlayer(param) { (data) in
            self.coachData.tracked.remove(at: sender.tag)
            self.athleteTblView.reloadData()
            delay(0.5) {
                self.athleteTblViewHeightConstraint.constant = self.athleteTblView.contentSize.height
            }
        }
    }
    
    @IBAction func clickToExpand(_ sender: UIButton) {
        let dict : PlayerMainModel = coachData.tracked[sender.tag]
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
        let dict : PlayerMainModel = coachData.tracked[sender.tag]
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
        serviceCallToSaveNote(note: note, player_id: player.id)
    }
    
    //MARK: - PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if type == 1 {
            collegeAffiliationTxt.text = collegeAffArr[row]
        }
        else if type == 2 {
            roleTxt.text = roleArr[row]
        }
        else if type == 3 {
            receiveEmailTxt.text = receiveEmailArr[row]
        }
    }
    
    func serviceCallToGetCoachDetail()
    {
        APIManager.shared.serviceCallToGetCoachDetail { (data) in
            self.coachData = CoachModel.init(dict: data)
            self.setCoachData()
        }
    }
    
    func setCoachData()
    {
        setButtonBackgroundImage(coachData.main.profile_image, btn: [profileImgBtn])
        nameLbl.text = coachData.main.name
        collegeNameLbl.attributedText = setColorAttribute("College Affiliation: ", coachData.collage.name)
        roleLbl.attributedText = setColorAttribute("Role: ", coachData.main.position)
        deskPhoneLbl.attributedText = setColorAttribute("Desk Phone: ", coachData.main.desk_phone)
        athleteTblView.reloadData()
        athleteTblViewHeightConstraint.constant = athleteTblView.contentSize.height
    }
    
    func setColorAttribute(_ firstString : String, _ subString : String) -> NSMutableAttributedString
    {
        let mainString = firstString + subString
        let range = (mainString as NSString).range(of: subString)
        let attribute = NSMutableAttributedString.init(string: mainString)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: BlackColor , range: range)
        return attribute
    }
    
    func serviceCallToSaveNote(note : String, player_id : String)
    {
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["player_id"] = player_id
        param["note"] = note
        
        APIManager.shared.serviceCallToSaveNote(param) { (data) in
            let index = self.coachData.tracked.firstIndex { (temp) -> Bool in
                temp.id == player_id
            }
            if index != nil
            {
                self.coachData.tracked[index!].note = note
                self.selectedAddEditNoteId = ""
                self.selectedExpandId = self.coachData.tracked[index!].id
                self.athleteTblView.reloadData()
                delay(0.5) {
                    self.athleteTblViewHeightConstraint.constant = self.athleteTblView.contentSize.height
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
