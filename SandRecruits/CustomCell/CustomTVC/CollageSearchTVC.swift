//
//  CollageSearchTVC.swift
//  SandRecruits
//
//  Created by PC on 29/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class CollageSearchTVC: UITableViewCell {
    
    @IBOutlet var imgBtn: Button!
    @IBOutlet var collegeNameLbl: Label!
    @IBOutlet var shortNameLbl: Label!
    @IBOutlet var addressLbl: Label!
    @IBOutlet var proBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
