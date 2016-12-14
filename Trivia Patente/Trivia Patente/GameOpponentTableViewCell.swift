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
    var userChosenCallback : ((User) -> Void)!
    @IBAction func playWithUser() {
        self.userChosenCallback(user)
    }
    
    var user : User! {
        didSet {
            self.avatarView.load(user: user)
            self.nameView.text = user.username
            self.detailView.text = "\(user.score!)"
            self.configureButtonAppearance()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarView.circleRounded()
        self.playButton.mediumRounded()
        // Initialization code
    }
    var buttonColor : UIColor {
        if user.last_game_won == false {
            return Colors.red_default
        }
        return Colors.green_default
    }
    var buttonTitle : String {
        if user.last_game_won == false {
            return "Rivincita"
        }
        return "Gioca ora"
    }
    
    func configureButtonAppearance() {
        self.playButton.layer.borderWidth = 1
        self.playButton.layer.borderColor = buttonColor.cgColor
        self.playButton.setTitle(buttonTitle, for: .normal)
        self.playButton.setTitleColor(buttonColor, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
