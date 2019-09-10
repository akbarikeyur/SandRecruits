//
//  FollowedTVC.swift
//  SandRecruits
//
//  Created by PC on 03/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class FollowedTVC: UITableViewCell {

    @IBOutlet var profileImgBtn: Button!
    @IBOutlet var nameLbl: Label!
    @IBOutlet var srLbl: Label!
    @IBOutlet var yearLbl: Label!
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
