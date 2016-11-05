//
//  LifesButtonItem.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class LifesButtonItem: UIBarButtonItem {
    @IBOutlet var lifesLabel : UILabel!
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var moreLifesButton : UIButton!
    
    var callback : (() -> Void)!
    var numberOfLifes : Int = 0 {
        didSet {
            lifesLabel.text = "\(numberOfLifes)"
            self.timeLabel.isHidden = (self.numberOfLifes == Constants.max_life_number )
            self.moreLifesButton.isHidden = !self.timeLabel.isHidden
        }
    }
    var remainingTime : Int = Constants.life_seconds_value {
        didSet {
            timeLabel.text = "\(remainingTime / 60):\(remainingTime % 60)"
        }
    }
    @IBAction func moreLifes() {
        callback()
    }
    init(callback : @escaping () -> Void) {
        super.init()
        self.callback = callback
        self.customView = Bundle.main.loadNibNamed("LifesButtonItem", owner: self, options: nil)?.first as! UIView?
        self.moreLifesButton.circleRounded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initCounter(lifes : Int, remainingTime : Int = Constants.life_seconds_value) {
        self.numberOfLifes = lifes
        self.remainingTime = remainingTime
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.remainingTime == 0 {
                if !self.timeLabel.isHidden {
                    self.numberOfLifes = self.numberOfLifes + 1
                    self.remainingTime = Constants.life_seconds_value
                } else {
                    timer.invalidate()
                }
            } else {
                self.remainingTime = self.remainingTime - 1
            }
        }
    }
}
