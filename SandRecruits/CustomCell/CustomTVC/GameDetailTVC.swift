//
//  GameDetailTVC.swift
//  SandRecruits
//
//  Created by PC on 30/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class GameDetailTVC: UITableViewCell {

    @IBOutlet var queLbl: Label!
    @IBOutlet var queViewHeightConstaint: NSLayoutConstraint!
    
    @IBOutlet var anslbl: Label!
    
    @IBOutlet var calenderBtn: UIButton!
    @IBOutlet var calenderBtnViewHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
