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
    @IBOutlet var usersImageView : [UIImageView]!
    @IBOutlet var iconLabels : [UILabel]!
    @IBOutlet var containerView : UIView!
    @IBOutlet weak var usersContainer: UIStackView!
    @IBOutlet var footerLabel : UILabel!
    @IBOutlet var footerContainerHeight: NSLayoutConstraint!
    
    // useful variables for graphic changes
    @IBOutlet weak var secondUserContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var secondUserContainerHeight: NSLayoutConstraint!
    let AVATAR_SIDE_LENGTH_SMALL = CGFloat(45)
    let AVATAR_SIDE_LENGTH_BIG = CGFloat(60)
    
    
    let handler = HTTPGame()
    @IBAction func playNewGame() {
        handler.newGame(id: self.opponent.id!) { response in
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
    var isDrew = false {
        didSet {
            self.titleLabel.text = self.titleFor(game: game)
        }
    }
    var isCancelled = false {
        didSet {
            self.titleLabel.text = self.titleFor(game: game)
        }
    }
    var scoreIncrement : Int! {
        didSet {
            self.scoreIncrementLabel.text = "\(scoreIncrement.toSignedString()) \(abs(scoreIncrement) == 1 ? "km" : "km")"
            self.titleLabel.text = self.titleFor(game: game)
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
            self.configureFooter(game: game)
        }
    }
    func configureFooter(game: Game) {
        if game.expired {
            self.footerLabel.text = "Il tempo per completare la partita è scaduto"
            self.footerContainerHeight.constant = RoundDetailsViewController.ENDED_CELL_FOOTER_HEIGHT
        } else
        {
            self.footerContainerHeight.constant = 0
        }
    }
    func titleFor(game : Game) -> String {
        if (isCancelled && game.ended == true && game.started == false) || (game.ended && (scoreIncrement == 0 || scoreIncrement == nil)) {
            self.hasVictory(victory: false)
            return "Partita annullata"
        } else if isDrew && game.winnerId == nil {
            self.hasVictory(victory: false)
            return "Hai pareggiato!"
        } else if game.won() {
            self.hasVictory(victory: true)
            return "Hai vinto!"
        }
        self.hasVictory(victory: true)
        return "Hai perso!"
    }
    func buttonTitleFor(game : Game) -> String {
        if game.won() {
            return "Sfida di nuovo"
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
    
    func hasVictory(victory: Bool)
    {
        let sideLength = victory ? AVATAR_SIDE_LENGTH_SMALL : AVATAR_SIDE_LENGTH_BIG
        let emoticons = victory ? "🏆😡":"🙄🙄"
        self.secondUserContainerWidth.constant = sideLength
        self.secondUserContainerHeight.constant = sideLength
        self.iconLabels[0].text = emoticons[0]
        self.iconLabels[1].text = emoticons[1]
        self.layoutIfNeeded()
        for imageView in usersImageView {
            imageView.circleRounded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.bigRounded()
        self.footerLabel.text = ""
        self.gameButton.mediumRounded()
        for imageView in usersImageView {
            imageView.circleRounded()
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = Colors.primary.cgColor
        }
        
    }
}
