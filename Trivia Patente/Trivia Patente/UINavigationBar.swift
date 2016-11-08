//
//  UINavigationBar.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 08/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension UINavigationBar {
    var titleColor: UIColor? {
        get {
            if let attributes = self.titleTextAttributes {
                return attributes[NSForegroundColorAttributeName] as? UIColor
            }
            return nil
        }
        set {
            if let value = newValue {
                self.titleTextAttributes = [NSForegroundColorAttributeName: value]
            }
        }
    }
}
