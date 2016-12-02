//
//  UIColor.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension UIColor {
    func darker(offset : CGFloat) -> UIColor {
        var red : CGFloat = 0,
           blue : CGFloat = 0,
          green : CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return UIColor(red: red - offset, green: green - offset, blue: blue - offset, alpha: 1)
    }
    func alpha(offset : CGFloat) -> UIColor {
        var alpha : CGFloat = 0
        self.getWhite(nil, alpha: &alpha)
        return self.withAlphaComponent(alpha + offset)
    }
    
    convenience init( hex: String) {
        var hex = hex
        var alpha: Float = 100
        let hexLength = hex.characters.count
        if !(hexLength == 7 || hexLength == 9) {
            // A hex must be either 7 or 9 characters (#RRGGBBAA)
            print("improper call to 'colorFromHex', hex length must be 7 or 9 chars (#GGRRBBAA)")
            self.init(white: 0, alpha: 1)
            return
        }
        
        if hexLength == 9 {
            // Note: this uses String subscripts as given below
            let lower_index = hex.index(hex.startIndex, offsetBy: 6)
            let upper_index = hex.index(hex.startIndex, offsetBy: 7)
            alpha = hex.substring(to: lower_index).floatValue
            hex = hex.substring(from: upper_index)
        }
        
        // Establishing the rgb color
        var rgb: UInt32 = 0
        let s: Scanner = Scanner(string: hex)
        // Setting the scan location to ignore the leading `#`
        s.scanLocation = 1
        // Scanning the int into the rgb colors
        s.scanHexInt32(&rgb)
        
        // Creating the UIColor from hex int
        let red = CGFloat((rgb & 0xFF0000) >> 16),
            green = CGFloat((rgb & 0x00FF00) >> 8),
            blue = CGFloat(rgb & 0x0000FF)
        print(red, green, blue, alpha)
        self.init(
            red: red / 255.0,
            green: green / 255.0,
            blue: blue / 255.0,
            alpha: CGFloat(alpha / 100)
        )
    }
}
