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
    
    var user : User! {
        didSet {
            if let fullName = user.fullName {
                self.nameView.text = fullName
            } else {
                self.nameView.text = user.username
            }
            self.avatarView.loadAvatar(candidate: user)
        }
    }
    var position : Int! {
        didSet {
            self.detailView.text = self.positionText
        }
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
