//
//  GameOpponentTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class GameOpponentTableViewCell: UITableViewCell {

    @IBOutlet var avatarView : UIImageView!
    @IBOutlet var nameView : UILabel!
    @IBOutlet var detailView : UILabel!

    @IBOutlet var playButton : UIButton!
    
    var handler = HTTPGame()
    @IBAction func playWithUser() {
        handler.newGame(id: user.id!) { response in
            if response.success == true {
                //TODO: send message to the user that confirm the invitation
            } else {
                //TODO: handle error
            }
        }
    }
    
    var user : User! {
        didSet {
            self.avatarView.loadAvatar(user: user)
            self.nameView.text = user.username
            self.detailView.text = "\(user.score!)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarView.circleRounded()
        self.playButton.mediumRounded()
        self.playButton.layer.borderWidth = 1
        self.playButton.layer.borderColor = Colors.green_default.cgColor
        self.playButton.setTitleColor(Colors.green_default, for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
