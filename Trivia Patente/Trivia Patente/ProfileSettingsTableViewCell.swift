//
//  ProfileSettingsTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 13/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class ProfileSettingsTableViewCell: SettingsTableViewCell {
    @IBOutlet var avatarView : UIImageView!
    @IBOutlet var nameView : UILabel!
    @IBOutlet var usernameView : UILabel!
    override func initValues() {
        super.initValues()
        if let user = SessionManager.currentUser {
            avatarView.load(user: user)
            if let fullname = user.fullName {
                nameView.text = fullname
            } else {
                nameView.text = "Nessun nome o cognome"
            }
            usernameView.text = "@\(user.username!)"
        }
        self.accessoryType = .disclosureIndicator
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.avatarView.circleRounded()
        // Initialization code
    }
    
    
}
