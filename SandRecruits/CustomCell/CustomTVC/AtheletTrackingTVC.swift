//
//  AtheletTrackingTVC.swift
//  SandRecruits
//
//  Created by PC on 02/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

protocol AtheletTrackingDelegate {
    func updateNoteText(note : String, player : PlayerMainModel)
}

class AtheletTrackingTVC: UITableViewCell {

    var delegate : AtheletTrackingDelegate?
    
    @IBOutlet var imgBtn: Button!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var srLbl: UILabel!
    @IBOutlet var yearLbl: UILabel!
    @IBOutlet var trackedLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var removeBtn: Button!
    @IBOutlet var removeBtnBottonImgView: UIImageView!
    @IBOutlet var removeBtnBackView: UIView!
    
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
    
    
    var player : PlayerMainModel = PlayerMainModel.init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickToSaveChange(_ sender: Any) {
        print(editTxt.text)
        delegate?.updateNoteText(note: editTxt.text, player : player)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
