//
//  EventDetailVC.swift
//  SandRecruits
//
//  Created by Keyur on 05/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import EventKit

class EventDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, AttenseesTVCDelegate {

    @IBOutlet weak var eventImgView: UIImageView!
    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var hostLbl: Label!
    @IBOutlet weak var sendRecruitView: UIView!
    @IBOutlet weak var sendRecruitsCV: UICollectionView!
    @IBOutlet weak var constraintSendRecruitView: NSLayoutConstraint!//100
    @IBOutlet var attendeesView: UIView!
    @IBOutlet weak var attendeesTblView: UITableView!
    @IBOutlet weak var constraintHeightAttendeesTblView: NSLayoutConstraint!
    @IBOutlet weak var eventNameLbl: Label!
    
    @IBOutlet weak var infoTblView: UITableView!
    @IBOutlet weak var infoTblViewHeightConstraint: NSLayoutConstraint!
    
    
    var attendeesData : [AttendeesModel] = [AttendeesModel]()
    var eventData : EventModel = EventModel.init()
    var event_id = ""
    var eventStore = EKEventStore()
    var selectedExpandId : String = ""
    var selectedAddEditId : String = ""
    var selectedAddEditNoteId : String = ""
    
    var arrEventInfo : [[String : String]] = [[String : String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        attendeesTblView.register(UINib.init(nibName: "CustomAttenseesTVC", bundle: nil), forCellReuseIdentifier: "CustomAttenseesTVC")
        sendRecruitsCV.register(UINib.init(nibName: "FollowedCVC", bundle: nil), forCellWithReuseIdentifier: "FollowedCVC")
        
        infoTblView.register(UINib.init(nibName: "EventDetailTVC", bundle: nil), forCellReuseIdentifier: "EventDetailTVC")
        
        
        serviceCallToGetEventDetail()
    }
    
    func setEventDetail()
    {
        setImageViewBackgroundImage(eventData.image, imgView: [eventImgView])
        let strDate = getDateStringFromDate(date: getDateFromDateString(strDate: eventData.start, format: "EEEE, MMM dd, yyyy")!, format: "MMM dd")
        dateLbl.text = strDate.replacingOccurrences(of: " ", with: "\n")
        
        nameLbl.text = eventData.name
        eventNameLbl.text = eventData.name
        hostLbl.text = "by " + eventData.host
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToRegisterForEvent(_ sender: Any) {
        self.view.endEditing(true)
        if eventData.register_for_event != ""
        {
            openUrlInSafari(strUrl: eventData.register_for_event)
//            if UIApplication.shared.canOpenURL(url)
//            {
//                let vc : AppWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "AppWebViewVC") as! AppWebViewVC
//                vc.strUrl = eventData.register_for_event
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == attendeesTblView {
            return attendeesData.count
        }else {
            return arrEventInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == attendeesTblView {
            let cell : CustomAttenseesTVC = attendeesTblView.dequeueReusableCell(withIdentifier: "CustomAttenseesTVC") as! CustomAttenseesTVC
            cell.delegate = self
            let dict : AttendeesModel = attendeesData[indexPath.row]
            cell.dict = dict
            setButtonBackgroundImage(dict.profile_image, btn: [cell.profilePicBtn])
            cell.nameLbl.text = dict.name
            cell.srLbl.text = "SR#: " + dict.sr
            cell.yearLbl.text = "Grad Year: " + dict.grandyear
            cell.poolLbl.text = "Pool: " + dict.pool
            cell.courtAssignmentLbl.text = "Court Assignment: " + dict.court_assignment
            cell.trackBtn.isSelected = (dict.track == "yes") ? true : false
            
            cell.expandBtn.tag = indexPath.row
            cell.expandBtn.addTarget(self, action: #selector(clickToExpand(_:)), for: .touchUpInside)
            
            cell.addNoteBtn.tag = indexPath.row
            cell.addNoteBtn.addTarget(self, action: #selector(clickToAddEditNote(_:)), for: .touchUpInside)
            cell.editNoteBtn.tag = indexPath.row
            cell.editNoteBtn.addTarget(self, action: #selector(clickToAddEditNote(_:)), for: .touchUpInside)
            
            cell.trackBtn.tag = indexPath.row
            cell.trackBtn.addTarget(self, action: #selector(clickToTrack(_:)), for: .touchUpInside)
            
            cell.editView.isHidden = true
            cell.addSaveView.isHidden = true
            cell.editBtnView.isHidden = true
            cell.addBtnView.isHidden = true
            cell.constraintHeightEditView.constant = 0
            cell.constraintHeightAddSaveView.constant = 0
            
            if isPlayerLogin()
            {
                cell.noteView.isHidden = true
            }
            else
            {
                cell.noteView.isHidden = false
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
                
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell : EventDetailTVC = infoTblView.dequeueReusableCell(withIdentifier: "EventDetailTVC") as! EventDetailTVC

            let dict = arrEventInfo[indexPath.row]
            cell.queTxt.text = dict["title"]
            if indexPath.row == 0 || indexPath.row == 1 {
                cell.ansTxt.attributedText = dict["value"]?.html2AttributedString
                cell.btnHeightConstraint.constant = 0
                cell.CalenderBtn.isHidden = true
            }
            else {
                cell.ansTxt.attributedText = dict["value"]?.html2AttributedString
                cell.CalenderBtn.isHidden = false
                cell.btnHeightConstraint.constant = 37
                cell.CalenderBtn.tag = indexPath.row
                cell.CalenderBtn.addTarget(self, action: #selector(self.clickToCalender), for: .touchUpInside)
                
                if indexPath.row == 2 {
                    cell.CalenderBtn.setTitle("Add to Calender", for: .normal)
                }else if indexPath.row == 3 {
                    cell.CalenderBtn.setTitle("View Map", for: .normal)
                }
                
                infoTblViewHeightConstraint.constant = infoTblView.contentSize.height
                
            }
            return cell
        }
    }
    
    func setEventDetailData() {
        arrEventInfo = [[String : String]]()
        var tempDict : [String : String] = [String : String]()
        if eventData.content != "" {
            tempDict["title"] = "Description"
            tempDict["value"] = eventData.content
            arrEventInfo.append(tempDict)
        }
        
        if eventData.schedule != "" {
            tempDict = [String : String]()
            tempDict["title"] = "Schedule"
            tempDict["value"] = eventData.schedule
            arrEventInfo.append(tempDict)
        }
        
        if eventData.start != "" {
            tempDict = [String : String]()
            tempDict["title"] = "Date and Time"
            tempDict["value"] = eventData.start
            arrEventInfo.append(tempDict)
        }

        if eventData.location != "" {
            tempDict = [String : String]()
            tempDict["title"] = "Location"
            tempDict["value"] = eventData.location
            arrEventInfo.append(tempDict)
        }
        
        infoTblView.reloadData()
        infoTblViewHeightConstraint.constant = infoTblView.contentSize.height
    }
    
    @objc func clickToCalender(sender : UIButton) {
        if sender.tag == 2 {
            SOGetPermissionCalendarAccess()
        }
        else if sender.tag == 3 {
            
            if eventData.location.trimmed == ""
            {
                return
            }
            let strUrl = GOOGLE_MAP_REDIRECT + eventData.location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            openUrlInSafari(strUrl: strUrl)
        }
    }
    
    @IBAction func clickToSync(_ sender: UIButton) {
        serviceCallToGetEventDetail()
        clickToCloseAttendeesView(self)
    }
    
    @IBAction func clickToExpand(_ sender: UIButton) {
        let dict : AttendeesModel = attendeesData[sender.tag]
        if selectedExpandId == dict.id
        {
            selectedExpandId = ""
        }
        else
        {
            selectedExpandId = dict.id
        }
        selectedAddEditNoteId = ""
        attendeesTblView.reloadData()
        delay(0.5) {
            self.updateAttendeesTableViewHeight()
        }
    }
    
    @IBAction func clickToAddEditNote(_ sender: UIButton) {
        let dict : AttendeesModel = attendeesData[sender.tag]
        if selectedAddEditNoteId == dict.id
        {
            selectedAddEditNoteId = ""
        }
        else
        {
            selectedAddEditNoteId = dict.id
        }
        selectedExpandId = ""
        attendeesTblView.reloadData()
        delay(0.5) {
            self.updateAttendeesTableViewHeight()
        }
    }
    
    func updateAttenseesNotes(note: String, dict: AttendeesModel) {
        print(note)
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["player_id"] = dict.id
        param["note"] = note
        APIManager.shared.serviceCallToSaveNote(param) { (data) in
            let index = self.attendeesData.firstIndex { (temp) -> Bool in
                temp.id == dict.id
            }
            if index != nil
            {
                self.attendeesData[index!].note = note
                self.selectedAddEditNoteId = ""
                self.selectedExpandId = self.attendeesData[index!].id
                self.attendeesTblView.reloadData()
                delay(0.5) {
                    self.updateAttendeesTableViewHeight()
                }
            }
        }
    }
    
    @IBAction func clickToTrack(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        let dict : AttendeesModel = attendeesData[sender.tag]
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["player_id"] = dict.id
        param["value"] = (sender.isSelected ? "yes" : "no")
        
        APIManager.shared.serviceCallToTrackPlayer(param) { (data) in
            
        }
    }
    
    //MARK:- CollectionView method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendeesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sendRecruitsCV.dequeueReusableCell(withReuseIdentifier: "FollowedCVC", for: indexPath) as! FollowedCVC
        cell.imgBtn.layer.cornerRadius = cell.frame.size.height/2
        cell.imgBtn.layer.masksToBounds = true
        setButtonBackgroundImage(attendeesData[indexPath.row].profile_image, btn: [cell.imgBtn])
        cell.countLbl.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: attendeesView)
        attendeesTblView.reloadData()
        self.updateAttendeesTableViewHeight()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let Height = sendRecruitsCV.frame.size.height
        return CGSize(width: Height, height: Height)
    }
    
    func SOGetPermissionCalendarAccess() {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            print("Authorised")
            addEventToCalendar()
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                {(granted, error) in
                    if !granted {
                        print("Access to store not granted")
                    }
            })
        default:
            print("Case Default")
        }
    }
    
    func addEventToCalendar()
    {
        let event:EKEvent = EKEvent(eventStore: eventStore)
        
        event.title = eventData.name
        event.startDate = getDateFromDateString(strDate: eventData.start, format: "dd-MM-yyyy hh:mm a")
        event.endDate = getDateFromDateString(strDate: eventData.end, format: "dd-MM-yyyy hh:mm a")
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch let e as NSError {
            print(e.description)
            return
        }
        self.dismiss(animated: true) {
            
        }
    }
 
    @IBAction func clickToCloseAttendeesView(_ sender: Any) {
        attendeesView.removeFromSuperview()
    }
    
    
    func serviceCallToGetEventDetail()
    {
        APIManager.shared.serviceCallToGetEventDetail(event_id) { (data) in
            if let event : [String : Any] = data["event"] as? [String : Any]
            {
                self.eventData = EventModel.init(dict: event)
                self.setEventDetail()
                self.setEventDetailData()
            }
            self.attendeesData = [AttendeesModel]()
            if let attendees : [[String : Any]] = data["attendees"] as? [[String : Any]]
            {
                for temp in attendees
                {
                    self.attendeesData.append(AttendeesModel.init(dict: temp))
                }
                self.sendRecruitsCV.reloadData()
            }
            if self.attendeesData.count == 0
            {
                self.constraintSendRecruitView.constant = 0
            }
            else
            {
                self.constraintSendRecruitView.constant = 100
            }
        }
    }
    
    func updateAttendeesTableViewHeight()
    {
        constraintHeightAttendeesTblView.constant = attendeesTblView.contentSize.height
    }


}
