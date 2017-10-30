//
//  LifesButtonItem.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class LifesButtonItem: UIBarButtonItem {
//    @IBOutlet var lifesLabel : UILabel!
//    @IBOutlet var moreLifesButton : UIButton!
    @IBOutlet var heartImageView : UIImageView!
//    {
//        didSet {
//            self.heartImageView.tintColor = Colors.error_default
//            self.heartImageView.image = self.heartImageView.image?.withRenderingMode(.alwaysTemplate)
//        }
//    }
    
    var callback : (() -> Void)!
//    var numberOfLifes : Int = 0 {
//        didSet {
//            lifesLabel.text = "\(numberOfLifes)"
//            self.moreLifesButton.isHidden = self.numberOfLifes != 0
//        }
//    }
    @IBAction func moreLifes() {
        callback()
    }
    init(callback : @escaping () -> Void) {
        super.init()
        self.callback = callback
        self.customView = Bundle.main.loadNibNamed("LifesButtonItem", owner: self, options: nil)?.first as! UIView?
//        self.customView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
//        self.moreLifesButton.circleRounded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
