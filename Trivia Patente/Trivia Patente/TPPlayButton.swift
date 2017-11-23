//
//  TPPlayButton.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 30/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPPlayButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? self.highlightBackgroundColor : self.normalBackgroundColor
        }
    }
    var highlightBackgroundColor : UIColor?
    var normalBackgroundColor : UIColor = .white
    
    override var tintColor: UIColor! {
        didSet {
            self.setTitleColor(tintColor, for: .normal)
            self.layer.borderColor = tintColor.cgColor
            self.highlightBackgroundColor = tintColor
        }
    }

    func set(for theGame : Game? = nil, theUser : User? = nil) {
        if let game = theGame {
            if game.ended {
                self.recapButton()
            } else if game.my_turn {
                self.playNowButton()
            } else {
                self.hisTurnButton()
            }
            
        } else if let user = theUser {
            if let last_result = user.last_game_won {
                if last_result {
                    self.playNowButton()
                } else {
                    self.revengeButton()
                }
            } else {
                self.playNowButton()
            }
        }
    }
    override func awakeFromNib() {
        self.mediumRounded()
        self.layer.borderWidth = 1
        self.setTitleColor(.white, for: .highlighted)
        super.awakeFromNib()
    }
    func chatButton() {
        self.setTitle("In attesa", for: .normal)
        self.isUserInteractionEnabled = false
        self.tintColor = Colors.gray_default
    }
    func hisTurnButton() {
        self.setTitle("Dettagli", for: .normal)
        self.isUserInteractionEnabled = true
        self.tintColor = Colors.yellow_default
    }
    func recapButton() {
        self.setTitle("Riepilogo", for: .normal)
        self.isUserInteractionEnabled = true
        self.tintColor = Colors.red_default
    }
    func playNowButton() {
        self.setTitle("Gioca ora", for: .normal)
        self.isUserInteractionEnabled = true
        self.tintColor = Colors.green_default
    }
    func revengeButton() {
        self.setTitle("Rivincita", for: .normal)
        self.isUserInteractionEnabled = true
        self.tintColor = Colors.red_default
    }
    

}
