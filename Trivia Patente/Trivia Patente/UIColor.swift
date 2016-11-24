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
}
