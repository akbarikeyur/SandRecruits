//
//  EventDetailTVC.swift
//  SandRecruits
//
//  Created by PC on 24/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class EventDetailTVC: UITableViewCell {

    @IBOutlet weak var queTxt: Label!
    @IBOutlet weak var ansTxt: Label!
    
    @IBOutlet weak var CalenderBtn: Button!
    @IBOutlet weak var btnHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
