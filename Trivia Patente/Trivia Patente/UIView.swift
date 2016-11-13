//
//  UIView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {

    func smallRounded(corners : UIRectCorner = .allCorners) {
        self.createCorners(radius: 3, corners: corners)
    }
    func mediumRounded(corners : UIRectCorner = .allCorners) {
        self.createCorners(radius: 10, corners: corners)
    }
    func circleRounded(corners : UIRectCorner = .allCorners) {
        self.createCorners(radius: self.frame.size.height / 2, corners: corners)
    }
    func shadow(radius : CGFloat, color : UIColor = .black) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = radius
    }
    func createCorners(radius : CGFloat, corners : UIRectCorner) {
        self.layer.masksToBounds = true
        if corners != .allCorners {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height:  radius))
            
            let maskLayer = CAShapeLayer()
        
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        } else {
            self.layer.cornerRadius = radius
        }
    }

}
