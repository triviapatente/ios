//
//  RankTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 07/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {
    
    @IBOutlet var avatarView : UIImageView!
    @IBOutlet var nameView : UILabel!
    @IBOutlet var detailView : UILabel!
    @IBOutlet var scoreView : UILabel!
    
    @IBOutlet var infoDisclosure : UIButton!
    
    @IBOutlet var infoBar : UINavigationBar!
    @IBOutlet var infoBackButton : UIBarButtonItem!
    
    let ANIMATION_DURATION = 0.2
    @IBAction func dismissInfoBox() {
        UIView.animate(withDuration: ANIMATION_DURATION) {
            self.infoBar.alpha = 0
        }
    }
    @IBAction func presentInfoBox() {
        UIView.animate(withDuration: ANIMATION_DURATION) {
            self.infoBar.alpha = 1
        }
    }
    
    var user : User! {
        didSet {
            self.setAppearance(for: user)
            if let fullName = user.fullName {
                self.nameView.text = fullName
            } else {
                self.nameView.text = user.username
            }
            self.scoreView.text = "\(user.score!)"
            self.avatarView.load(user: user)
        }
    }
    var infoBackgroundColor : UIColor {
        get {
            return (user.isMe()) ? Colors.primary : UIColor.white
        }
    }
    var infoContentColor : UIColor {
        get {
            return (user.isMe()) ? UIColor.white : Colors.primary
        }
    }
    func setAppearance(for user: User) {
        self.nameView.textColor = infoContentColor
        self.detailView.textColor = infoContentColor
        self.scoreView.textColor = infoContentColor
        self.infoDisclosure.tintColor = infoContentColor
        self.contentView.backgroundColor = infoBackgroundColor
        
        self.infoBar.titleColor = infoContentColor
        self.infoBackButton.tintColor = infoContentColor
        self.infoBar.barTintColor = infoBackgroundColor

    }
    var position : Int! {
        didSet {
            self.detailView.text = self.positionText
            self.infoBar.topItem?.title = "Posizione: \(infoPositionText)"
            self.detailView.isHidden = (position > 99)
            self.infoDisclosure.isHidden = !self.detailView.isHidden
        }
    }
    var infoPositionText : String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: position as NSNumber)!
    }
    var positionText : String {
        get {
            if position == 1 {
                return "🏎"
            } else if position == 2 {
                return "🚗"
            } else if position == 3 {
                return "🚲"
            }
            return "\(position!)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarView.circleRounded()
        // Initialization code
    }
    
}
