//
//  GCStackItemContainerView.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 11/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class GCStackItemContainerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var contentView : UIView?
    var loaded : Bool = false
    
    func loadLayout(from nibName: String) {
        contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first! as? UIView
        contentView!.translatesAutoresizingMaskIntoConstraints = false
        contentView?.mediumRounded()
        self.addSubview(contentView!)
        self.addConstraint(NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: contentView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute:.bottom, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: contentView!, attribute: .leadingMargin, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: contentView!, attribute: .trailingMargin, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0))
        self.layoutIfNeeded()
    }

}
