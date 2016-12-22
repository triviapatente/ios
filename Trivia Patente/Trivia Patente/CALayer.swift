//
//  CALayer.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
            case UIRectEdge.top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
                break
            case UIRectEdge.left:
                border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
                break
            default:
                break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}
