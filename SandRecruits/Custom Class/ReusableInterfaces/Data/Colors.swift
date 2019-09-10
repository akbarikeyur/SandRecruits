//
//  Colors.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit

var ClearColor : UIColor = UIColor.clear //0
var WhiteColor : UIColor = UIColor.white //1
var DarkGrayColor : UIColor = colorFromHex(hex: "282828") //2
var LightGrayColor : UIColor = colorFromHex(hex: "9A9A9A") //3
var ExtraLightGrayColor : UIColor = colorFromHex(hex: "F8F8F8") //4
var OrangeColor : UIColor = colorFromHex(hex: "F9A028") //5
var BlackColor : UIColor = UIColor.black   //6
var LightBlueColor : UIColor = colorFromHex(hex: "F0F2F7") //7
var BlueColor : UIColor = colorFromHex(hex: "3773E0") //8
var YellowColor : UIColor = colorFromHex(hex: "EFCE4A") //9
var StateBlueColor : UIColor = colorFromHex(hex: "4292B5") //10
var BlueBGColor : UIColor = colorFromHex(hex: "4BA4C0") //11
var LightOrange : UIColor = colorFromHex(hex: "FDD193") //15
var ButtonBackGroundColor : UIColor = colorFromHex(hex: "CECECE") //16
var DarkRedColor : UIColor = colorFromHex(hex: "702323") //17


enum ColorType : Int32 {
    case Clear = 0
    case White = 1
    case DarkGray = 2
    case LightGray = 3
    case ExtraLightGray = 4
    case Orange = 5
    case Black = 6
    case LightBcolor = 7
    case Blue = 8
    case Yellow = 9
    case StateBlue = 10
    case BlueBG = 11
    case LOrange = 15
    case ButtonBackColor = 16
    case DarkRed = 17
}

extension ColorType {
    var value: UIColor {
        get {
            switch self {
            case .Clear: //0
                return ClearColor
            case .White: //1
                return WhiteColor
            case .DarkGray: //2
                return DarkGrayColor
            case .LightGray: //3
                return LightGrayColor
            case .ExtraLightGray: //4
                return ExtraLightGrayColor
            case .Orange : //5
                return OrangeColor
            case .Black : //6
                return BlackColor
            case .LightBcolor : //7
                return LightBlueColor
            case .Blue : //8
                return BlueColor
            case .Yellow : //9
                return YellowColor
            case .StateBlue : //10
                return StateBlueColor
            case .BlueBG : //11
                return BlueBGColor
            case .LOrange : //15
                return LightOrange
            case .ButtonBackColor : //16
                return ButtonBackGroundColor
            case .DarkRed : //17
                return DarkRedColor

            }
        }
    }
}

enum GradientColorType : Int32 {
    case Clear = 0
    case App = 1
}

extension GradientColorType {
    var layer : GradientLayer {
        get {
            let gradient = GradientLayer()
            switch self {
            case .Clear: //0
                gradient.frame = CGRect.zero
            case .App: //1
                gradient.colors = [
                    LightOrange.cgColor,
                    WhiteColor.cgColor
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint(x: 0.8, y: 1.0)
                gradient.endPoint = CGPoint(x: 0.8, y: 0.0)
//                gradient.startPoint = CGPoint.zero
//                gradient.endPoint = CGPoint(x: 1, y: 0)
            }
            
            return gradient
        }
    }
}

