//
//  OtherUserProfileVC.swift
//  SandRecruits
//
//  Created by Keyur on 29/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CustomGlanceCVC: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
}

class CustomCollegeTVC: UITableViewCell {
    @IBOutlet weak var profilePicBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
}

class OtherUserProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var playerNameLbl: Label!
    @IBOutlet weak var playerSRLbl: Label!
    @IBOutlet weak var playerGraduationLbl: Label!
    
    @IBOutlet weak var editBtn: Button!
    @IBOutlet weak var trackBtn: Button!
    @IBOutlet weak var printBtn: Button!
    
    @IBOutlet weak var playerInfoLbl: Label!
    @IBOutlet weak var atheleticsLbl: Label!
    @IBOutlet weak var academicsLbl: Label!
    @IBOutlet weak var photoVideoLbl: Label!
    
    @IBOutlet weak var playerInfoBtn: Button!
    @IBOutlet weak var atheleticsBtn: Button!
    @IBOutlet weak var academicsBtn: Button!
    @IBOutlet weak var photoVideoBtn: Button!
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var constraintHeightMainContainerView: NSLayoutConstraint!
    
    @IBOutlet var infoView: UIView!
    @IBOutlet weak var glanceCV: UICollectionView!
    @IBOutlet weak var constraintHeightGlanceCV: NSLayoutConstraint!
    @IBOutlet weak var aboutLbl: Label!
    @IBOutlet weak var constraintHeightAboutLbl: NSLayoutConstraint!
    @IBOutlet weak var generalTblView: UITableView!
    @IBOutlet weak var constraintHeightGeneralTblView: NSLayoutConstraint!
    @IBOutlet weak var physicalInfoTblView: UITableView!
    @IBOutlet weak var constraintHeightPhysicalInfoTblView: NSLayoutConstraint!
    
    //Atheletics Info
    @IBOutlet var atheleticsView: UIView!
    @IBOutlet weak var athleticsGeneralTblView: UITableView!
    @IBOutlet weak var constraintHeightAthleticsGeneralTblView: NSLayoutConstraint!
    @IBOutlet weak var athleticsTourTblView: UITableView!
    @IBOutlet weak var constrintHeightAthleticsTourcTblView: NSLayoutConstraint!
    @IBOutlet weak var athelticsClubTblView: UITableView!
    @IBOutlet weak var constrintHeightAthleticsClubTblView: NSLayoutConstraint!
    @IBOutlet weak var athelticsIndoorTblView: UITableView!
    @IBOutlet weak var constrintHeightAthleticsIndoorTblView: NSLayoutConstraint!
    
    //Academic Info
    @IBOutlet var academicView: UIView!
    @IBOutlet weak var academicTblView: UITableView!
    @IBOutlet weak var constraintHeightacademicTblView: NSLayoutConstraint!
    
    //Photo Video
    @IBOutlet var photoVideoView: UIView!
    @IBOutlet weak var videoTblView: UITableView!
    @IBOutlet weak var constraintHeightVideoTblView: NSLayoutConstraint!
    @IBOutlet weak var photoTblView: UITableView!
    @IBOutlet weak var constraintHeightPhotoTblView: NSLayoutConstraint!
    @IBOutlet weak var noVideoLbl: Label!
    @IBOutlet weak var noPhotoLbl: Label!
    @IBOutlet weak var uploadPhotoVideoView: UIView!
    @IBOutlet weak var constraintHeightUploadPhotoVideoView: NSLayoutConstraint!
    
    
    //Share Player View
    @IBOutlet var sharePlayerView: UIView!
    @IBOutlet weak var shareProfileSecondView: View!
    @IBOutlet weak var shareProfileFirstView: View!
    @IBOutlet weak var searchCollegeTxt: TextField!
    @IBOutlet weak var collegeTblView: UITableView!
    @IBOutlet weak var shareEmailTxt: TextField!
    @IBOutlet weak var shareProfileMessageTxtView: TextView!
    
    //Share Coach View
    @IBOutlet var shareCoachView: UIView!
    @IBOutlet weak var shareEmailCoachTxt: TextField!
    @IBOutlet weak var shareMessageCoachTxtView: TextView!
    @IBOutlet weak var shareCoachViewTitleLbl: Label!
    @IBOutlet weak var shareCoachViewBtn: Button!
    
    
    var arrPlayerGeneralInfo : [[String : String]] = [[String : String]]()
    var arrPlayerPhysicalInfo : [[String : String]] = [[String : String]]()
    
    var arrAthleticsGeneralInfo : [[String : String]] = [[String : String]]()
    var arrAthleticsTourInfo : [[String : String]] = [[String : String]]()
    var arrAthleticsBeachClubInfo : [[String : String]] = [[String : String]]()
    var arrAthleticsIndoorClubInfo : [[String : String]] = [[String : String]]()
    
    var arrAcademicsInfo : [[String : String]] = [[String : String]]()
    
    var player_id = ""
    var playerData : PlayerDetailModel = PlayerDetailModel.init()
    
    var arrCollageList : [CollageModel] = [CollageModel]()
    var arrSelectedCollageList : [CollageModel] = [CollageModel]()
    var arrSearchCollageList : [CollageModel] = [CollageModel]()
    
    var page_no : Int = 1
    var limit : Int = 10
    var track_player : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        generalTblView.register(UINib.init(nibName: "CustomInformationTVC", bundle: nil), forCellReuseIdentifier: "CustomInformationTVC")
        physicalInfoTblView.register(UINib.init(nibName: "CustomInformationTVC", bundle: nil), forCellReuseIdentifier: "CustomInformationTVC")
        photoTblView.register(UINib.init(nibName: "CustomPhotoVideoTVC", bundle: nil), forCellReuseIdentifier: "CustomPhotoVideoTVC")
        videoTblView.register(UINib.init(nibName: "CustomPhotoVideoTVC", bundle: nil), forCellReuseIdentifier: "CustomPhotoVideoTVC")
        
        searchCollegeTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        serviceCallToGetPlayerDetail()
        clickToSelectMenu(playerInfoBtn)
        printBtn.isHidden = true
        setUIDesigning()
    }
    
    func setUIDesigning()
    {
        if isPlayerLogin() {
            editBtn.isHidden = false
            trackBtn.isHidden = true
        }else{
            editBtn.isHidden = true
            trackBtn.isHidden = false
            
            trackBtn.isSelected = (track_player.lowercased() == "yes")
        }
    }
    
    @IBAction func clickToSelectMenu(_ sender: UIButton) {
        resetAllView()
        if sender == playerInfoBtn {
            selectMenu(btn: playerInfoBtn, lbl: playerInfoLbl)
            setPlayerInfoView()
        }
        else if sender == atheleticsBtn {
            selectMenu(btn: atheleticsBtn, lbl: atheleticsLbl)
            setAtheleticsView()
        }
        else if sender == academicsBtn {
            selectMenu(btn: academicsBtn, lbl: academicsLbl)
            setAcademicView()
        }
        else if sender == photoVideoBtn {
            selectMenu(btn: photoVideoBtn, lbl: photoVideoLbl)
            setPhotoVideoView()
        }
    }
    
    @IBAction func clickToEditProfile(_ sender: Any) {
        openUrlInSafari(strUrl: Edit_Player_Profile)
        /*
        let url : URL = URL(string: Edit_Player_Profile)!
        if UIApplication.shared.canOpenURL(url)
        {
            let vc : AppWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "AppWebViewVC") as! AppWebViewVC
            vc.strUrl = Edit_Player_Profile
            self.navigationController?.pushViewController(vc, animated: true)
        }
        */
    }
    
    @IBAction func clickToTrackBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        serviceCallToTrackPlayer(value: ((sender.isSelected) ? "yes" : "no"))
    }
    
    @IBAction func clickToPrintBtn(_ sender: UIButton) {
        if player_id == "" {
            player_id = AppModel.shared.currentUser.uId
        }
        openUrlInSafari(strUrl: (PRINT_PROFILE + player_id))
    }
    
    
    func resetAllView()
    {
        playerInfoBtn.isSelected = false
        atheleticsBtn.isSelected = false
        academicsBtn.isSelected = false
        photoVideoBtn.isSelected = false
        
        playerInfoLbl.isHighlighted = false
        atheleticsLbl.isHighlighted = false
        academicsLbl.isHighlighted = false
        photoVideoLbl.isHighlighted = false
        
        infoView.removeFromSuperview()
    }
    
    func selectMenu(btn : UIButton, lbl : UILabel)
    {
        btn.isSelected = true
        lbl.isHighlighted = true
    }
    
    //MARK:- CollectionView Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CustomGlanceCVC = glanceCV.dequeueReusableCell(withReuseIdentifier: "CustomGlanceCVC", for: indexPath) as! CustomGlanceCVC
        switch indexPath.row {
        case 0:
            cell.imgView.image = UIImage.init(named: "location_pin")
            cell.titleLbl.text = "Location"
            cell.valueLbl.text = playerData.playerinfo.location
            break
        case 1:
            cell.imgView.image = UIImage.init(named: "email")
            cell.titleLbl.text = "Email Address"
            cell.valueLbl.text = playerData.playerinfo.player_email
            break
        case 2:
            cell.imgView.image = UIImage.init(named: "school")
            cell.titleLbl.text = "School Name"
            cell.valueLbl.text = playerData.playerinfo.school_name
            break
        case 3:
            cell.imgView.image = UIImage.init(named: "gpa")
            cell.titleLbl.text = "GPA"
            cell.valueLbl.text = playerData.playerinfo.gpa
            break
        case 4:
            cell.imgView.image = UIImage.init(named: "beach_club")
            cell.titleLbl.text = "Beach Club"
            cell.valueLbl.text = playerData.playerinfo.beachclub
            break
        case 5:
            cell.imgView.image = UIImage.init(named: "education")
            cell.titleLbl.text = "Current Education Level"
            cell.valueLbl.text = playerData.playerinfo.currenteducationlevel
            break
        default:
            break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: glanceCV.frame.size.width/2, height: 140)
    }
    
    //MARK:- Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == generalTblView {
            return arrPlayerGeneralInfo.count
        }
        else if tableView == physicalInfoTblView {
            return arrPlayerPhysicalInfo.count
        }
        else if tableView == athleticsGeneralTblView {
            return arrAthleticsGeneralInfo.count
        }
        else if tableView == athleticsTourTblView {
            return arrAthleticsTourInfo.count
        }
        else if tableView == athelticsClubTblView {
            return arrAthleticsBeachClubInfo.count
        }
        else if tableView == athelticsIndoorTblView {
            return arrAthleticsIndoorClubInfo.count
        }
        else if tableView == academicTblView {
            return arrAcademicsInfo.count
        }
        else if tableView == photoTblView{
            return playerData.photosandvidoes.photo_urls.count
        }
        else if tableView == videoTblView {
            return playerData.photosandvidoes.video_urls.count
        }
        else if tableView == collegeTblView {
            return (searchCollegeTxt.text?.trimmed != "") ? arrSearchCollageList.count : arrCollageList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == photoTblView || tableView == videoTblView  {
            return 200
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == photoTblView  {
            let cell : CustomPhotoVideoTVC = photoTblView.dequeueReusableCell(withIdentifier: "CustomPhotoVideoTVC", for: indexPath) as! CustomPhotoVideoTVC
            cell.playBtn.isHidden = true
            setImageViewBackgroundImage(playerData.photosandvidoes.photo_urls[indexPath.row], imgView: [cell.photoImg])
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == videoTblView  {
            let cell : CustomPhotoVideoTVC = videoTblView.dequeueReusableCell(withIdentifier: "CustomPhotoVideoTVC", for: indexPath) as! CustomPhotoVideoTVC
            cell.playBtn.isHidden = false
            let imgUrl = "https://img.youtube.com/vi/" + playerData.photosandvidoes.video_urls[indexPath.row] + "/0.jpg"
            setImageViewBackgroundImage(imgUrl, imgView: [cell.photoImg])
            cell.playBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(clickToPlayVideo(_:)), for: .touchUpInside)
            //https://youtu.be/3Wf29RiKp70
            cell.playBtn.isHidden = false
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == collegeTblView  {
            let cell : CustomCollegeTVC = collegeTblView.dequeueReusableCell(withIdentifier: "CustomCollegeTVC", for: indexPath) as! CustomCollegeTVC
            let dict = (searchCollegeTxt.text?.trimmed != "") ? arrSearchCollageList[indexPath.row] : arrCollageList[indexPath.row]
            setButtonBackgroundImage(dict.profile_image, btn: [cell.profilePicBtn])
            cell.nameLbl.text = dict.name
            cell.locationLbl.text = dict.city + ", " + dict.state
            cell.selectBtn.tag = indexPath.row
            cell.selectBtn.addTarget(self, action: #selector(clickToSelectCollege(_:)), for: .touchUpInside)
            let index = arrSelectedCollageList.firstIndex { (temp) -> Bool in
                temp.id == dict.id
            }
            if index != nil
            {
                cell.selectBtn.isSelected = true
            }
            else{
                cell.selectBtn.isSelected = false
            }
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell : CustomInformationTVC = generalTblView.dequeueReusableCell(withIdentifier: "CustomInformationTVC", for: indexPath) as! CustomInformationTVC
            
            var dict : [String : String] = [String : String]()
            if tableView == generalTblView
            {
                dict = arrPlayerGeneralInfo[indexPath.row]
            }
            else if tableView == physicalInfoTblView {
                dict = arrPlayerPhysicalInfo[indexPath.row]
            }
            else if tableView == athleticsGeneralTblView {
                dict = arrAthleticsGeneralInfo[indexPath.row]
            }
            else if tableView == athleticsTourTblView {
                dict =  arrAthleticsTourInfo[indexPath.row]
            }
            else if tableView == athelticsClubTblView {
                dict =  arrAthleticsBeachClubInfo[indexPath.row]
            }
            else if tableView == athelticsIndoorTblView {
                dict =  arrAthleticsIndoorClubInfo[indexPath.row]
            }
            else if tableView == academicTblView {
                dict =  arrAcademicsInfo[indexPath.row]
            }
            
            cell.queLbl.text = dict["title"]
            cell.ansLbl.text = dict["value"]
            
            cell.selectionStyle = .none
            return cell
        }        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == photoTblView  {
            displayFullImage([playerData.photosandvidoes.photo_urls[indexPath.row]], 0)
        }
    }
    
    @IBAction func clickToPlayVideo(_ sender: UIButton) {
        let videoUrl = "https://youtu.be/" + playerData.photosandvidoes.video_urls[sender.tag]
        openUrlInSafari(strUrl: videoUrl)
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToUploadPhotoVideo(_ sender: Any) {
        
        let strUrl = "https://sandrecruits.com/mobile-photo-video-upload/?iosapp=" + AppModel.shared.currentUser.uId
        openUrlInSafari(strUrl: strUrl)
        /*
        let url : URL = URL(string: strUrl)!
        if UIApplication.shared.canOpenURL(url)
        {
            let vc : AppWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "AppWebViewVC") as! AppWebViewVC
            vc.strUrl = strUrl
            self.navigationController?.pushViewController(vc, animated: true)
        }
        */
    }
    
    
    func serviceCallToGetPlayerDetail()
    {
        var params : [String : Any] = [String : Any]()
        params["user_id"] = AppModel.shared.currentUser.uId
        if !isPlayerLogin()
        {
            params["player_id"] = player_id
        }
        APIManager.shared.serviceCallToGetPlayerDetail(params) { (data) in
            self.playerData = PlayerDetailModel.init(dict: data)
            self.track_player = self.playerData.main.track_player
            self.setUIDesigning()
            self.setPlayerData()
        }
    }
    
    func setPlayerData(){
        setButtonBackgroundImage(playerData.main.profile_image, btn: [profilePicBtn])
        playerNameLbl.text = playerData.main.name
        playerSRLbl.text = "SR# : " + playerData.main.sr
        playerGraduationLbl.text = "Graduation Year:" + playerData.main.grandyear
        
        setPlayerInfoView()
    }
    
    
    func setPlayerInfoView()
    {
        glanceCV.reloadData()
        constraintHeightGlanceCV.constant = 140 * 3
        
        aboutLbl.text = playerData.playerinfo.about.html2String
        constraintHeightAboutLbl.constant = aboutLbl.bounds.size.height
        
        //Set General Info
        arrPlayerGeneralInfo = [[String : String]]()
        var tempDict : [String : String] = [String : String]()
        if playerData.playerinfo.birthdate != "" {
            tempDict["title"] = "Birth Date"
            tempDict["value"] = playerData.playerinfo.birthdate
            arrPlayerGeneralInfo.append(tempDict)
        }
        
        if playerData.playerinfo.parents_email != "" {
            tempDict["title"] = "Parent's Email"
            tempDict["value"] = playerData.playerinfo.parents_email
            arrPlayerGeneralInfo.append(tempDict)
        }
        
        if playerData.playerinfo.mailing_address != "" {
            tempDict["title"] = "Mailing Address"
            tempDict["value"] = playerData.playerinfo.mailing_address
            arrPlayerGeneralInfo.append(tempDict)
        }
        
        if playerData.playerinfo.parents_name != "" {
            tempDict["title"] = "Parent's Name"
            tempDict["value"] = playerData.playerinfo.parents_name
            arrPlayerGeneralInfo.append(tempDict)
        }
        
        if playerData.playerinfo.phone != "" {
            tempDict["title"] = "Athlete's Phone Number"
            tempDict["value"] = playerData.playerinfo.phone
            arrPlayerGeneralInfo.append(tempDict)
        }
        
        if playerData.playerinfo.scholarship != "" {
            tempDict["title"] = "What type of scholarship are you pursuing?"
            tempDict["value"] = playerData.playerinfo.scholarship
            arrPlayerGeneralInfo.append(tempDict)
        }
        
        if playerData.playerinfo.collage_location_preference.count > 0 {
            
            var arrTempData : [String] = [String]()
            for temp in playerData.playerinfo.collage_location_preference
            {
                arrTempData.append(temp.label)
            }
            tempDict["title"] = "College Location Preference"
            tempDict["value"] = arrTempData.joined(separator: "\n")
            arrPlayerGeneralInfo.append(tempDict)
        }
        
        if playerData.playerinfo.willing_travel != "" {
            tempDict["title"] = "Are you willing to travel out of state?"
            tempDict["value"] = playerData.playerinfo.willing_travel
            arrPlayerGeneralInfo.append(tempDict)
        }
        
        if playerData.playerinfo.money_contribute != "" {
            tempDict["title"] = "How much money could you contribute to your education if you receive a partial scholarship?"
            tempDict["value"] = playerData.playerinfo.money_contribute
            arrPlayerGeneralInfo.append(tempDict)
        }
        generalTblView.reloadData()
        
        //Set Physical Info
        arrPlayerPhysicalInfo = [[String : String]]()
        if playerData.playerinfo.height != "" {
            tempDict["title"] = "Height"
            tempDict["value"] = playerData.playerinfo.height
            arrPlayerPhysicalInfo.append(tempDict)
        }
        
        if playerData.playerinfo.weight != "" {
            tempDict["title"] = "Weight"
            tempDict["value"] = playerData.playerinfo.weight
            arrPlayerPhysicalInfo.append(tempDict)
        }
        
        if playerData.playerinfo.standing_reach != "" {
            tempDict["title"] = "Standing Reach"
            tempDict["value"] = playerData.playerinfo.standing_reach
            arrPlayerPhysicalInfo.append(tempDict)
        }
        
        if playerData.playerinfo.vertical_touch != "" {
            tempDict["title"] = "Vertical Touch"
            tempDict["value"] = playerData.playerinfo.vertical_touch
            arrPlayerPhysicalInfo.append(tempDict)
        }
        
        if playerData.playerinfo.vertical_jump != "" {
            tempDict["title"] = "Vertical Jump"
            tempDict["value"] = playerData.playerinfo.vertical_jump
            arrPlayerPhysicalInfo.append(tempDict)
        }
        
        if playerData.playerinfo.hit != "" {
            tempDict["title"] = "What hand do you hit with?"
            tempDict["value"] = playerData.playerinfo.hit
            arrPlayerPhysicalInfo.append(tempDict)
        }
        
        physicalInfoTblView.reloadData()
        setPlayerInfoViewHeight()
        displaySubViewtoParentView(mainContainerView, subview: infoView)
        delay(1.0) {
            self.setPlayerInfoViewHeight()
        }
    }
    
    func setPlayerInfoViewHeight()
    {
        constraintHeightAboutLbl.constant = aboutLbl.requiredHeight
        constraintHeightGeneralTblView.constant = generalTblView.contentSize.height
        constraintHeightPhysicalInfoTblView.constant = physicalInfoTblView.contentSize.height
        constraintHeightMainContainerView.constant = 345 + constraintHeightAboutLbl.constant + constraintHeightGlanceCV.constant + constraintHeightGeneralTblView.constant + constraintHeightPhysicalInfoTblView.constant
    }
    
    func setAtheleticsView()
    {
        //Set Physical Info
        arrAthleticsGeneralInfo = [[String : String]]()
        var tempDict : [String : String] = [String : String]()
        if playerData.athletics.describe_your_ideal_teammate != "" {
            tempDict["title"] = "Describe your ideal partner"
            tempDict["value"] = playerData.athletics.describe_your_ideal_teammate
            arrAthleticsGeneralInfo.append(tempDict)
        }
        
        if playerData.athletics.position != "" {
            tempDict["title"] = "What beach Position do you play?"
            tempDict["value"] = playerData.athletics.position
            arrAthleticsGeneralInfo.append(tempDict)
        }
        
        if playerData.athletics.are_you_registered_with_the_ncaa != "" {
            tempDict["title"] = "Are you registered with the NCAA Eligibility Center?"
            tempDict["value"] = playerData.athletics.are_you_registered_with_the_ncaa
            arrAthleticsGeneralInfo.append(tempDict)
        }
        
        if playerData.athletics.describe_why_you_like_beach_volleyball != "" {
            tempDict["title"] = "Why do you like beach volleyball?"
            tempDict["value"] = playerData.athletics.describe_why_you_like_beach_volleyball
            arrAthleticsGeneralInfo.append(tempDict)
        }
        
        athleticsGeneralTblView.reloadData()
        
        arrAthleticsTourInfo = [[String : String]]()
        if playerData.athletics.what_tournament_series_do_you_play != "" {
            tempDict["title"] = "What tournament series do you play?"
            tempDict["value"] = playerData.athletics.what_tournament_series_do_you_play
            arrAthleticsTourInfo.append(tempDict)
        }
        if playerData.athletics.how_many_times_have_you_placed_1st_in_a_tournament != "" {
            tempDict["title"] = "How many times have you placed 1st in a tournament?"
            tempDict["value"] = playerData.athletics.how_many_times_have_you_placed_1st_in_a_tournament
            arrAthleticsTourInfo.append(tempDict)
        }
        
        if playerData.athletics.how_many_times_have_you_finished_in_the_top_3_in_a_tournament != "" {
            tempDict["title"] = "How many times have you finished in the top 3 in tournament?"
            tempDict["value"] = playerData.athletics.how_many_times_have_you_finished_in_the_top_3_in_a_tournament
            arrAthleticsTourInfo.append(tempDict)
        }
        
        if playerData.athletics.tournament_results.count > 0 {
            var arrTempData : [String] = [String]()
            for temp in playerData.athletics.tournament_results
            {
                arrTempData.append(temp)
            }
            tempDict["title"] = "Tournament Results"
            tempDict["value"] = arrTempData.joined(separator: "\n")
            arrAthleticsTourInfo.append(tempDict)
        }
        
        if playerData.athletics.schedule != "" {
            tempDict["title"] = "Upcoming Schedule"
            tempDict["value"] = playerData.athletics.schedule
            arrAthleticsTourInfo.append(tempDict)
        }
        
        athleticsTourTblView.reloadData()
        
        arrAthleticsBeachClubInfo = [[String : String]]()
        if playerData.athletics.how_many_years_have_you_played_beach_volleyball != "" {
            tempDict["title"] = "How many years have you played beach volleyball?"
            tempDict["value"] = playerData.athletics.how_many_years_have_you_played_beach_volleyball
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.do_you_currently_play_with_a_beach_club != "" {
            tempDict["title"] = "Do you currently play with a beach club?"
            tempDict["value"] = playerData.athletics.do_you_currently_play_with_a_beach_club
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.beach_club_name != "" {
            tempDict["title"] = "Beach Club Name"
            tempDict["value"] = playerData.athletics.beach_club_name
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.beach_club_website != "" {
            tempDict["title"] = "Beach Club Website"
            tempDict["value"] = playerData.athletics.beach_club_website
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.beach_club_directors_name != "" {
            tempDict["title"] = "Beach Club Director's Name"
            tempDict["value"] = playerData.athletics.beach_club_directors_name
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.beach_club_directors_phone_number != "" {
            tempDict["title"] = "Director's Phone Number"
            tempDict["value"] = playerData.athletics.beach_club_directors_phone_number
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.beach_club_directors_email_address != "" {
            tempDict["title"] = "Director's Email Address"
            tempDict["value"] = playerData.athletics.beach_club_directors_email_address
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.do_you_currently_play_high_school_or_college_beach != "" {
            tempDict["title"] = "Do you currently play high school or junior college beach?"
            tempDict["value"] = playerData.athletics.do_you_currently_play_high_school_or_college_beach
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.school_name_hs != "" {
            tempDict["title"] = "School Name"
            tempDict["value"] = playerData.athletics.school_name_hs
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.coachs_name_hs != "" {
            tempDict["title"] = "Coach's Name"
            tempDict["value"] = playerData.athletics.coachs_name_hs
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.coachs_phone_number_hs != "" {
            tempDict["title"] = "Coach's Phone Number"
            tempDict["value"] = playerData.athletics.coachs_phone_number_hs
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        if playerData.athletics.coachs_email_address_hs != "" {
            tempDict["title"] = "Coach's Email Address"
            tempDict["value"] = playerData.athletics.coachs_email_address_hs
            arrAthleticsBeachClubInfo.append(tempDict)
        }
        athelticsClubTblView.reloadData()
        
        arrAthleticsIndoorClubInfo = [[String : String]]()
        if playerData.athletics.how_many_years_have_you_played_indoor_volleyball != "" {
            tempDict["title"] = "How many years have you played indoor volleyball?"
            tempDict["value"] = playerData.athletics.how_many_years_have_you_played_indoor_volleyball
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.do_you_currently_play_with_an_indoor_club != "" {
            tempDict["title"] = "Do you currently play with an indoor club?"
            tempDict["value"] = playerData.athletics.do_you_currently_play_with_an_indoor_club
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.position_played != "" {
            tempDict["title"] = "Indoor Position Played"
            tempDict["value"] = playerData.athletics.position_played
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.indoor_club_name != "" {
            tempDict["title"] = "Indoor club name"
            tempDict["value"] = playerData.athletics.indoor_club_name
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.indoor_club_website != "" {
            tempDict["title"] = "Indoor club website"
            tempDict["value"] = playerData.athletics.indoor_club_website
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.indoor_club_directors_name != "" {
            tempDict["title"] = "Indoor club director’s name"
            tempDict["value"] = playerData.athletics.indoor_club_directors_name
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.indoor_club_directors_phone_number != "" {
            tempDict["title"] = "Indoor club director’s phone number"
            tempDict["value"] = playerData.athletics.indoor_club_directors_phone_number
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.indoor_club_directors_email_address != "" {
            tempDict["title"] = "Indoor club director’s email address"
            tempDict["value"] = playerData.athletics.indoor_club_directors_email_address
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.do_you_currently_play_high_school_or_college_indoor != "" {
            tempDict["title"] = "Do you currently play high school or college indoor?"
            tempDict["value"] = playerData.athletics.do_you_currently_play_high_school_or_college_indoor
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.school_name_hsc != "" {
            tempDict["title"] = "School name"
            tempDict["value"] = playerData.athletics.school_name_hsc
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.coachs_name_hsc != "" {
            tempDict["title"] = "Coach's name"
            tempDict["value"] = playerData.athletics.coachs_name_hsc
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.coachs_phone_number_hsc != "" {
            tempDict["title"] = "Coach's phone number"
            tempDict["value"] = playerData.athletics.coachs_phone_number_hsc
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        if playerData.athletics.coachs_email_address_hsc != "" {
            tempDict["title"] = "Coach's email address"
            tempDict["value"] = playerData.athletics.coachs_email_address_hsc
            arrAthleticsIndoorClubInfo.append(tempDict)
        }
        athelticsIndoorTblView.reloadData()
        setAthelticsVieHeight()
        displaySubViewtoParentView(mainContainerView, subview: atheleticsView)
        delay(1.0) {
            self.setAthelticsVieHeight()
        }
    }
    
    func setAthelticsVieHeight()
    {
        self.constraintHeightAthleticsGeneralTblView.constant = self.athleticsGeneralTblView.contentSize.height
        self.constrintHeightAthleticsTourcTblView.constant = self.athleticsTourTblView.contentSize.height
        self.constrintHeightAthleticsClubTblView.constant = self.athelticsClubTblView.contentSize.height
        self.constrintHeightAthleticsIndoorTblView.constant = self.athelticsIndoorTblView.contentSize.height
        
        self.constraintHeightMainContainerView.constant = 340 + self.constraintHeightAthleticsGeneralTblView.constant + self.constrintHeightAthleticsTourcTblView.constant + self.constrintHeightAthleticsClubTblView.constant + self.constrintHeightAthleticsIndoorTblView.constant
    }
    
    func setAcademicView()
    {
        arrAcademicsInfo = [[String : String]]()
        var tempDict : [String : String] = [String : String]()
        if playerData.academics.currenteducationlevel != "" {
            tempDict["title"] = "Current Education Level"
            tempDict["value"] = playerData.academics.currenteducationlevel
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.school != "" {
            tempDict["title"] = "School Info"
            tempDict["value"] = playerData.academics.school
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.gpa != "" {
            tempDict["title"] = "GPA"
            tempDict["value"] = playerData.academics.gpa
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.verbal_sat != "" {
            tempDict["title"] = "Verbal SAT"
            tempDict["value"] = playerData.academics.verbal_sat
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.math_sat != "" {
            tempDict["title"] = "Math SAT"
            tempDict["value"] = playerData.academics.math_sat
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.cumulative_sat != "" {
            tempDict["title"] = "Cumulative SAT"
            tempDict["value"] = playerData.academics.cumulative_sat
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.act != "" {
            tempDict["title"] = "ACT"
            tempDict["value"] = playerData.academics.act
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.class_rank != "" {
            tempDict["title"] = "Class Rank"
            tempDict["value"] = playerData.academics.class_rank
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.class_size != "" {
            tempDict["title"] = "Class Size"
            tempDict["value"] = playerData.academics.class_size
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.academic_honors != "" {
            tempDict["title"] = "Academic Honors"
            tempDict["value"] = playerData.academics.academic_honors
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.desired_cour_of_study != "" {
            tempDict["title"] = "Desired Course(s) of Study"
            tempDict["value"] = playerData.academics.desired_cour_of_study
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.excracurricular_activties != "" {
            tempDict["title"] = "Extracurricular Activities"
            tempDict["value"] = playerData.academics.excracurricular_activties
            arrAcademicsInfo.append(tempDict)
        }
        if playerData.academics.hobbies != "" {
            tempDict["title"] = "Hobbies"
            tempDict["value"] = playerData.academics.hobbies
            arrAcademicsInfo.append(tempDict)
        }
        
        academicTblView.reloadData()
        setAcademicHeight()
        displaySubViewtoParentView(mainContainerView, subview: academicView)
        delay(1.0) {
            self.setAcademicHeight()
        }
    }
    
    func setAcademicHeight()
    {
        constraintHeightacademicTblView.constant = academicTblView.contentSize.height
        constraintHeightMainContainerView.constant = 100 + constraintHeightacademicTblView.constant
    }
    
    func setPhotoVideoView()
    {
        photoTblView.reloadData()
        videoTblView.reloadData()
        setPhotoVideoHeight()
        displaySubViewtoParentView(mainContainerView, subview: photoVideoView)
        delay(1.0) {
            self.setPhotoVideoHeight()
        }
    }
    
    func setPhotoVideoHeight()
    {
        if playerData.photosandvidoes.photo_urls.count == 0
        {
            constraintHeightPhotoTblView.constant = 40
            noPhotoLbl.isHidden = false
        }
        else
        {
            constraintHeightPhotoTblView.constant = photoTblView.contentSize.height
            noPhotoLbl.isHidden = true
        }
        
        if playerData.photosandvidoes.video_urls.count == 0
        {
            constraintHeightVideoTblView.constant = 40
            noVideoLbl.isHidden = false
        }
        else
        {
            constraintHeightVideoTblView.constant = videoTblView.contentSize.height
            noVideoLbl.isHidden = true
        }
        
        if isPlayerLogin() {
            uploadPhotoVideoView.isHidden = false
            constraintHeightUploadPhotoVideoView.constant = 50
        }else{
            uploadPhotoVideoView.isHidden = true
            constraintHeightUploadPhotoVideoView.constant = 0
        }
        
        constraintHeightMainContainerView.constant = 180 + constraintHeightPhotoTblView.constant + constraintHeightVideoTblView.constant + constraintHeightUploadPhotoVideoView.constant
    }
    
    func serviceCallToTrackPlayer(value : String)
    {
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["player_id"] = player_id
        param["value"] = value
        
        APIManager.shared.serviceCallToTrackPlayer(param) { (data) in
            var dict : [String : Any] = [String : Any]()
            dict["track_player"] = value
            dict["id"] = self.player_id
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_TRACK_STATUS), object: dict)
        }
    }
    
    //MARK:- Share Player Profile
    @IBAction func clickToShareProfile(_ sender: Any) {
        self.view.endEditing(true)
        if isPlayerLogin()
        {
            arrSelectedCollageList = [CollageModel]()
            arrSearchCollageList = [CollageModel]()
            searchCollegeTxt.text = ""
            shareEmailTxt.text = ""
            shareProfileMessageTxtView.text = ""
            if arrCollageList.count == 0
            {
                getCollageList()
            }
            shareProfileFirstView.isHidden = false
            shareProfileSecondView.isHidden = true
            displaySubViewtoParentView(self.view, subview: sharePlayerView)
        }
        else
        {
            shareCoachViewTitleLbl.text = "Share " + playerData.main.name
            shareCoachViewBtn.setTitle(shareCoachViewTitleLbl.text, for: .normal)
            shareEmailCoachTxt.text = ""
            shareMessageCoachTxtView.text = ""
            displaySubViewtoParentView(self.view, subview: shareCoachView)
        }
    }
    
    @IBAction func clickToCloseSharePlayerProfileView(_ sender: Any) {
        self.view.endEditing(true)
        sharePlayerView.removeFromSuperview()
    }
    
    @IBAction func clickToSelectCollege(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let dict = (searchCollegeTxt.text?.trimmed != "") ? arrSearchCollageList[sender.tag] : arrCollageList[sender.tag]
        let index = arrSelectedCollageList.firstIndex { (temp) -> Bool in
            temp.id == dict.id
        }
        if index != nil
        {
            arrSelectedCollageList.remove(at: index!)
        }
        else{
            arrSelectedCollageList.append(dict)
        }
    }
    
    @IBAction func clickToSharePlayerFirstView(_ sender: Any) {
        self.view.endEditing(true)
        shareProfileFirstView.isHidden = true
        shareProfileSecondView.isHidden = false
    }
    
    @IBAction func clickTobackSharePlayerView(_ sender: Any) {
        self.view.endEditing(true)
        shareProfileFirstView.isHidden = false
        shareProfileSecondView.isHidden = true
    }
    
    
    @IBAction func clickToSubbmitSharePlayerProfile(_ sender: Any) {
        self.view.endEditing(true)
        
        if arrSelectedCollageList.count == 0 && shareEmailTxt.text?.trimmed == "" {
            displayToast("Please select college or enter email address.")
        }
        else if shareEmailTxt.text?.trimmed != "" && !shareEmailTxt.text!.isValidEmail {
            displayToast("Invalid email address.")
        }
        else
        {
            var arrTempData : [String] = [String]()
            for temp in arrSelectedCollageList
            {
                arrTempData.append(temp.id)
            }
            
            var param : [String : Any] = [String : Any]()
            param["user_id"] = AppModel.shared.currentUser.uId
            param["colleges"] = arrTempData.joined(separator: ",")
            param["input_email"] = shareEmailTxt.text
            param["message"] = shareProfileMessageTxtView.text
            
            APIManager.shared.serviceCallToShareProfile(param) {
                displayToast("Profile shared successfully.")
                self.clickToCloseSharePlayerProfileView(self)
            }
        }
    }
    
    func getCollageList()
    {
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        //param["page_no"] = page_no
        param["limit"] = -1
        
        APIManager.shared.serviceCallToGetCollageList(param) { (data, total) in
            if let collageData : [[String : Any]] = data["colleges"] as? [[String : Any]]
            {
                if self.page_no == 1
                {
                    self.arrCollageList = [CollageModel]()
                }
                for temp in collageData
                {
                    self.arrCollageList.append(CollageModel.init(dict: temp))
                }
                self.collegeTblView.reloadData()
            }
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if textField == searchCollegeTxt {
            arrSearchCollageList = [CollageModel]()
            
            arrSearchCollageList = arrCollageList.filter({ (temp) -> Bool in
                let nameTxt: NSString = temp.name! as NSString
                return (nameTxt.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
            collegeTblView.reloadData()
        }
    }
    
    //MARK:- Share Coach Profile
    
    @IBAction func clickToCloseCoachShareView(_ sender: Any) {
        self.view.endEditing(true)
        shareCoachView.removeFromSuperview()
    }
    
    
    @IBAction func clickToSubmitShareProfileCoachView(_ sender: Any) {
        self.view.endEditing(true)
        if shareEmailCoachTxt.text?.trimmed == "" {
            displayToast("Please enter email address.")
        }
        else if !shareEmailCoachTxt.text!.isValidEmail {
            displayToast("Invalid email address.")
        }
        else
        {
            var arrTempData : [String] = [String]()
            for temp in arrSelectedCollageList
            {
                arrTempData.append(temp.id)
            }
            
            var param : [String : Any] = [String : Any]()
            param["user_id"] = AppModel.shared.currentUser.uId
            param["player_id"] = player_id
            param["input_email"] = shareEmailCoachTxt.text
            param["message"] = shareMessageCoachTxtView.text
            
            APIManager.shared.serviceCallToShareProfile(param) {
                displayToast("Profile shared successfully.")
                self.clickToCloseCoachShareView(self)
            }
        }
    }
    
}
