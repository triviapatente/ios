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
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
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
    func getBorderGradientLayer(width : CGFloat) -> CAGradientLayer {
        let center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        let circlePath = UIBezierPath(arcCenter: center, radius: (frame.size.width - width) / 2.0, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        let frontLayer = borderFrontLayer
        frontLayer.path = circlePath.cgPath
        frontLayer.lineWidth = width;
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: .zero, size: self.frame.size)
        layer.locations = [0.01, 0.8]
        layer.mask = frontLayer
        return layer
    }
    func rotatingBorder(color : UIColor, width : CGFloat = 3) {
        self.layer.removeAllAnimations()
        self.layer.borderWidth = 0
//        self.layer.sublayers?.removeAll()
        let gradientLayer = self.getBorderGradientLayer(width: width)
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(gradientLayer)
        self.set(rotatingBorderColor: color)
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = Float.infinity
        gradientLayer.add(rotateAnimation, forKey: nil)
    }
    func set(rotatingBorderColor color : UIColor) {
        if let layer = self.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer {
            let offset = CGFloat(0.4)
            let clearerColor = color == .white ? color.alpha(offset: -offset) : color.darker(offset: -offset)
            layer.colors = [color.cgColor, clearerColor.cgColor]
        }
    }
    
    func snapshotView(scale: CGFloat = 0.0, isOpaque: Bool = true) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .none
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func currentFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return view
            }
        }
        
        return nil
    }
    func blur(blurRadius: CGFloat) -> UIImage? {
        guard let blur = CIFilter(name: "CIGaussianBlur") else { return nil }
        
        let image = self.snapshotView(scale: 1.0, isOpaque: true)
        blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let ciContext  = CIContext(options: nil)
        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage!
        let boundingRect = CGRect(x: 0,
                                  y: 0,
                                  width: frame.width,
                                  height: frame.height)
            
        let cgImage = ciContext.createCGImage(result!, from: boundingRect)!
        return UIImage(cgImage: cgImage)
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
    func swing()
    {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.5
        animation.values = [0.785, -0.785, 0.785, -0.785, 0]
        self.layer.add(animation, forKey: "swing")
    }
    func shadow(radius : CGFloat, color : UIColor = .black, yOffset: CGFloat = 0.0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: yOffset)
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
        self.layer.cornerRadius = 0.0
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
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = self.superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}
