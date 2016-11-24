//
//  TPInviteTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class InviteTableViewCell: TPExpandableTableViewCell {

    @IBOutlet var avatarView : UIImageView!
    @IBOutlet var nameView : UILabel!
    @IBOutlet var acceptButton : UIButton!
    @IBOutlet var refuseButton : UIButton!
    
    var handler = HTTPGame()
    
    
    @IBAction func process(sender : UIButton) {
        let accept = (sender == acceptButton)
        handler.process_invite(game_id: invite.gameId!, accepted: accept) { response in
            if response.success == true {
                //TODO: go to game page
                self.delegate.removeCell(for: self.item)
            } else {
                //TODO error handler
            }
        }
        
    }
    
    override var item : Base! {
        didSet {
            self.invite = item as! Invite
        }
    }
    var invite : Invite! {
        didSet {
            self.nameView.text = invite.sender?.username
            self.avatarView.load(user: invite.sender)
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
    
}
