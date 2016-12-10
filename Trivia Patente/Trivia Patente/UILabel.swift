//
//  UILabel.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 26/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension UILabel {

    override open func copy() -> Any {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData)!
    }
    var requiredHeight : CGFloat {
        get {
            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
            let label : UILabel = UILabel(frame: frame)
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = self.font
            label.text = self.text
            label.sizeToFit()
            return label.frame.height
        }
    }
}
