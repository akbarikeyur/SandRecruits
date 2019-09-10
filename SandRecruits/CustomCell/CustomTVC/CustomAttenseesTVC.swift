//
//  CustomAttenseesTVC.swift
//  SandRecruits
//
//  Created by Keyur on 07/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

protocol AttenseesTVCDelegate {
    func updateAttenseesNotes(note : String, dict : AttendeesModel)
}

class CustomAttenseesTVC: UITableViewCell {
    
    
    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var srLbl: Label!
    @IBOutlet weak var yearLbl: Label!
    @IBOutlet weak var poolLbl: Label!
    @IBOutlet weak var courtAssignmentLbl: Label!
    @IBOutlet weak var trackBtn: Button!
    
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var constraintHeightEditView: NSLayoutConstraint!//110
    @IBOutlet weak var noteLbl: Label!
    @IBOutlet weak var editTxt: TextView!
    @IBOutlet weak var addBtnView: UIView!
    @IBOutlet weak var addNoteBtn: Button!
    @IBOutlet weak var editBtnView: UIView!
    @IBOutlet weak var editNoteBtn: Button!
    @IBOutlet weak var addSaveView: UIView!
    @IBOutlet weak var constraintHeightAddSaveView: NSLayoutConstraint!//55
    @IBOutlet weak var noteView: UIView!
    
    var dict : AttendeesModel = AttendeesModel.init()
    var delegate : AttenseesTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickToSave(_ sender: Any) {
        delegate?.updateAttenseesNotes(note: editTxt.text, dict: dict)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
