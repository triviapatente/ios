//
//  GameEndedTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 04/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class GameEndedTableViewCell: UITableViewCell {
    @IBOutlet var gameButton : UIButton!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var scoreIncrementLabel : UILabel!
    @IBOutlet var arrowImageView : UIImageView!
    @IBOutlet var usersImageView : [UIImageView]!
    @IBOutlet var containerView : UIView!
    
    let handler = HTTPGame()
    @IBAction func playNewGame() {
        handler.newGame(id: opponent.id!) { response in
            self.createGameCallback(response)
        }
    }
    var createGameCallback : ((TPNewGameResponse) -> Void)!
    @IBAction func playWithUser() {
        
    }
    var partecipations : [Partecipation]! {
        didSet {
            if let partecipation = self.partecipations.first(where: {$0.isMine()}) {
                self.scoreIncrement = partecipation.scoreIncrement
            }
        }
    }
    var scoreIncrement : Int! {
        didSet {
            self.scoreIncrementLabel.text = "\(scoreIncrement.toSignedString())"
            self.arrowImageView.image = self.arrowFor(increment: scoreIncrement)
        }
    }
    var users : [User]! {
        didSet {
            self.users.sort(by: {$0.0.id == game.winnerId})
            for i in 0..<usersImageView.count {
                let user = self.users[i]
                self.usersImageView[i].load(user: user)
            }
        }
    }
    var opponent : User {
        return self.users.first(where: {$0.id != SessionManager.currentUser?.id})!
    }
    var game : Game! {
        didSet {
            self.titleLabel.text = self.titleFor(game: game)
            self.configureButton(game: game)
        }
    }
    func arrowFor(increment : Int) -> UIImage {
        let name = (increment > 0) ? "up_score_arrow" : "down_score_arrow"
        return UIImage(named: name)!
    }
    func titleFor(game : Game) -> String {
        if game.won() {
            return "Hai vinto!"
        }
        return "Hai perso!"
    }
    func buttonTitleFor(game : Game) -> String {
        if game.won() {
            return "Gioca ancora"
        }
        return "Rivincita"
    }
    func configureButton(game : Game) {
        let won = game.won()
        let buttonTitle = self.buttonTitleFor(game: game)
        self.gameButton.setTitle(buttonTitle, for: .normal)
        self.gameButton.backgroundColor = (won) ? Colors.green_default : Colors.red_default
        self.gameButton.setTitleColor(.white, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.bigRounded()
        self.gameButton.mediumRounded()
        for imageView in usersImageView {
            imageView.circleRounded()
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = Colors.primary.cgColor
        }
        
    }
}
