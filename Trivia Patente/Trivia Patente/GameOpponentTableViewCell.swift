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

    @IBOutlet var playButton : TPPlayButton!
    
    var handler = HTTPGame()
    var userChosenCallback : ((User) -> Void)!
    @IBAction func playWithUser() {
        self.userChosenCallback(user)
    }
    
    var user : User! {
        didSet {
            self.avatarView.load(user: user)
            self.nameView.text = user.displayName
            self.detailView.text = "\(user.score!)"
            self.playButton.set(theUser: user)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarView.circleRounded()
        // Initialization code
    }
    
}
