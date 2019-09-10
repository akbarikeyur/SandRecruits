//
//  EventsVC.swift
//  SandRecruits
//
//  Created by PC on 29/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class EventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConstraint: NSLayoutConstraint!
    
    var arrEventData : [EventModel] = [EventModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.register(UINib(nibName: "EventsTVC", bundle: nil), forCellReuseIdentifier: "EventsTVC")
        serviceCallToGetEventList()
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
    
    //MARK; - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEventData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "EventsTVC", for: indexPath) as! EventsTVC
        
        let dict = arrEventData[indexPath.row]
        setImageViewBackgroundImage(dict.image, imgView: [cell.eventImgView])
        cell.titleLbl.text = dict.name
        cell.timeLbl.text = dict.start + " to " + dict.end
        cell.addressLbl.text = dict.location
        
        tblViewHeightConstraint.constant = tblView.contentSize.height
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : EventDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
        vc.event_id = arrEventData[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func serviceCallToGetEventList()
    {
        APIManager.shared.serviceCallToGetEventList { (data) in
            self.arrEventData = [EventModel]()
            for temp in data
            {
                self.arrEventData.append(EventModel.init(dict: temp))
            }
            self.tblView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
