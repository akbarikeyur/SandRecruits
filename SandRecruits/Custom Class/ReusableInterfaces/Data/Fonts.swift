//
//  Fonts.swift
//  Cozy Up
//
//  Created by Amisha on 22/05/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import Foundation

import UIKit

let MONT_BOLD = "Montserrat-Bold"
let MONT_REGULAR = "Montserrat-Regular"

let HIND_MEDIUM = "Hind-Medium"
let HIND_REGULAR = "Hind-Regular"
let HIND_BOLD = "Hind-Bold"

enum FontType : String {
    case Clear = ""
    case MontserrstBold = "mb"
    case MontserrstRegular = "mr"
    case HindRegular = "hr"
    case HindMedium = "hm"
    case Hindbold = "hb"
   
}


extension FontType {
    var value: String {
        get {
            switch self {
            case .Clear:
                return MONT_REGULAR
            
            case .MontserrstRegular:
                return MONT_REGULAR
            case .MontserrstBold:
                return MONT_BOLD
            case .HindRegular:
                return HIND_REGULAR
            case .HindMedium:
                return HIND_MEDIUM
            case .Hindbold:
                return HIND_BOLD
            
            }
        }
    }
}

