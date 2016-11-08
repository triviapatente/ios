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
            self.avatarView.loadAvatar(candidate: user)
        }
    }
    func setAppearance(for user: User) {
        self.nameView.textColor = (user.isMe()) ? UIColor.white : Colors.primary
        self.detailView.textColor = (user.isMe()) ? UIColor.white : Colors.primary
        self.scoreView.textColor = (user.isMe()) ? UIColor.white : Colors.primary
        self.infoDisclosure.tintColor = (user.isMe()) ? UIColor.white : Colors.primary
        self.contentView.backgroundColor = (user.isMe()) ? Colors.primary : UIColor.white
        
        self.infoBar.titleColor = (user.isMe()) ? UIColor.white : Colors.primary

        if let top_item = self.infoBar.topItem {
            self
            if let item = top_item.backBarButtonItem {
                item.tintColor = (user.isMe()) ? UIColor.white : Colors.primary
            }
        }
        self.infoBar.barTintColor = (user.isMe()) ? Colors.primary : UIColor.white

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
