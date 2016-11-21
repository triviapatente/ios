//
//  TPInviteTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class InviteTableViewCell: TPRecentTableViewCell {

    @IBOutlet var avatarView : UIImageView!
    @IBOutlet var nameView : UILabel!
    @IBOutlet var acceptButton : UIButton!
    @IBOutlet var refuseButton : UIButton!
    
    @IBAction func process(sender : UIButton) {
        let accept = (sender == acceptButton)
        
    }
    
    override var item : Base! {
        didSet {
            self.invite = item as! Invite
        }
    }
    var invite : Invite! {
        didSet {
            self.nameView.text = invite.sender?.username
            self.avatarView.loadAvatar(user: invite.sender)
            //TODO: set user
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarView.circleRounded()
        self.acceptButton.circleRounded()
        self.refuseButton.circleRounded()
        self.set(Colors.accept_color, for: self.acceptButton)
        self.set(Colors.refuse_color, for: self.refuseButton)
    }
    func set(_ color : UIColor, for button: UIButton) {
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.setTitleColor(color, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
