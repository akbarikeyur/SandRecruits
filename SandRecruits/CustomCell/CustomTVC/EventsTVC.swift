//
//  EventsTVC.swift
//  SandRecruits
//
//  Created by PC on 29/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class EventsTVC: UITableViewCell {

    @IBOutlet var eventImgView: UIImageView!
    @IBOutlet var titleLbl: Label!
    @IBOutlet var timeLbl: Label!
    @IBOutlet var addressLbl: Label!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
