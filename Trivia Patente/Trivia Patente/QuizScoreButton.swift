//
//  QuizScoreButton.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 09/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class QuizScoreButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setScore(scoreNumber: Int32?) {
        if let score = scoreNumber {
            if score == 0 {
                self.setImage(UIImage(named: "simple_tick"), for: .normal)
                super.setTitle(nil, for: .normal)
            } else {
                self.setImage(nil, for: .normal)
                super.setTitle("\(score)", for: .normal)
            }
            var color = Colors.red_default
            if score < 5 {
                color = Colors.orange_default
            }
            if score < 3 {
                color = Colors.yellow_default
            }
            if score < 1{
                color = Colors.green_default
                self.setTitle(nil, for: .normal)
                self.setImage(UIImage(named: "simple_tick"), for: .normal)
            }
            self.setColor(color: color)
        } else {
            self.setTitle("-", for: .normal)
            self.setImage(nil, for: .normal)
            self.setColor(color: Colors.red_default)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.circleRounded()
    }
    
    private func setColor(color: UIColor) {
        self.backgroundColor = color
        self.darkerBorder(of: 0.1, width: 2.5)
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        assert(true, "Use setScore!")
    }

}
