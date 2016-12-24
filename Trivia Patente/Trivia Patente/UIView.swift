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
    func bigRounded(corners : UIRectCorner = .allCorners) {
        self.createCorners(radius: 17, corners: corners)
    }
    func circleRounded(corners : UIRectCorner = .allCorners) {
        self.createCorners(radius: self.frame.size.height / 2, corners: corners)
    }
    func fade(duration : Double = 0.2) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = kCATransitionFade
        self.window?.layer.add(transition, forKey: nil)
    }
    
    var borderFrontLayer : CAShapeLayer {
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.strokeEnd = 1.0
        return circleLayer
    }
    func getBorderGradientLayer(color : UIColor, width : CGFloat) -> CAGradientLayer {
        let offset = CGFloat(0.4)
        let clearerColor = color == .white ? color.alpha(offset: -offset) : color.darker(offset: -offset)
        let center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        let circlePath = UIBezierPath(arcCenter: center, radius: (frame.size.width - width) / 2.0, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        let frontLayer = borderFrontLayer
        frontLayer.path = circlePath.cgPath
        frontLayer.lineWidth = width;
        
        let layer = CAGradientLayer()
        layer.colors = [color.cgColor, clearerColor.cgColor]
        layer.frame = CGRect(origin: .zero, size: self.frame.size)
        layer.locations = [0.01, 0.8]
        layer.mask = frontLayer
        return layer
    }
    func rotatingBorder(color : UIColor, width : CGFloat = 3) {
        self.layer.removeAllAnimations()
        self.layer.sublayers?.removeAll()
        let gradientLayer = self.getBorderGradientLayer(color: color, width: width)
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(gradientLayer)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = Float.infinity
        gradientLayer.add(rotateAnimation, forKey: nil)
    }
    func shadowSelect() {
        self.layer.shadowOpacity = 0
        UIView.animate(withDuration: 0.2) {
            self.layer.shadowOpacity = 1
        }
    }
    func shadowDeselect() {
        self.layer.shadowOpacity = 1
        UIView.animate(withDuration: 0.2) {
            self.layer.shadowOpacity = 0
        }
    }
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.5
        animation.values = [10, -10, 10, -10, 5, -5, 2, -2, 0]
        self.layer.add(animation, forKey: "shake")
    }
    func shadow(radius : CGFloat, color : UIColor = .black) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
    }
    func darkerBorder(of value : CGFloat, width : CGFloat) {
        self.layer.borderWidth = width
        if let color = self.backgroundColor {
            self.layer.borderColor = color.darker(offset: value).cgColor
        }
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
