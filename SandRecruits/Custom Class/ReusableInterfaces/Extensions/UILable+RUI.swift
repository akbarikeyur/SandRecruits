//
//  UILable+RUI.swift
//  SandRecruits
//
//  Created by Keyur on 04/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import Foundation

extension UILabel{
    
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}
