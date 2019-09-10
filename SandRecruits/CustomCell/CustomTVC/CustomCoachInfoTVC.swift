//
//  CustomCoachInfoTVC.swift
//  SandRecruits
//
//  Created by Keyur on 05/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CustomCoachInfoTVC: UITableViewCell {

    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var positionLbl: Label!
    @IBOutlet weak var phoneLbl: Label!
    @IBOutlet weak var deskPhoneLbl: Label!
    @IBOutlet weak var emailLbl: Label!
    @IBOutlet weak var bioLbl: Label!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
