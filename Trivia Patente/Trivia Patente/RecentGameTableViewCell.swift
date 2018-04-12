//
//  RecentGameTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class RecentGameTableViewCell: TPExpandableTableViewCell {
    @IBOutlet var controlLights : UIImageView!
    @IBOutlet var avatarView : UIImageView!
    @IBOutlet var usernameView : UILabel!
    @IBOutlet var hintView : UILabel!
    @IBOutlet var buttonView : TPPlayButton!
    @IBOutlet var opponentNameView : UILabel!
    @IBOutlet var myNameView : UILabel!
    @IBOutlet var opponentScoreView : UILabel!
    @IBOutlet var myScoreView : UILabel!
    @IBOutlet var progressView : UIProgressView!
    
    override var item : Base! {
        didSet {
            self.game = item as! Game
        }
    }
    @IBAction func gotoGame() {
        self.delegate.select(item: item)
    }
    var game : Game! {
        didSet {
            changeState(for: game)
            usernameView.text = game.opponent.displayName
            //TODO: load async with cache
            avatarView.load(user: game.opponent)
            opponentNameView.text = game.opponent.name ?? game.opponent.username
            myNameView.text = "Tu"
            opponentScoreView.text = "\(game.opponentScore!)"
            myScoreView.text = "\(game.myScore!)"
            progressView.progress = getProgress()
            handleWinning()
        }
    }
    func handleWinning() {
        guard let winnerId = game.winnerId, game.started else {
            return
        }
        if winnerId == SessionManager.currentUser?.id {
            myNameView.text = "🏆" + myNameView.text!
        } else {
            opponentNameView.text! += "🏆"
        }
    }
    func getProgress() -> Float {
        let myAnswers = 20 - game.remainingAnswersCount
        return Float(myAnswers) / 20
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    func changeState(for game : Game) {
        buttonView.set(for: game)
        hintView.text = hint(for : game)
        controlLights.image = lightsImage(for: game)
    }
    func hint(for game : Game) -> String {
        if game.ended {
            if !game.started {
                return "Partita annullata"
            } else if let winner = game.winnerId {
                if winner == SessionManager.currentUser?.id {
                    return "Hai vinto!"
                } else {
                    return "Hai perso!"
                }
            } else {
                return "Pareggio!"
            }
        } else {
            let remainingAnswers = game.remainingAnswersCount!
            if remainingAnswers == 1 {
                return "1 domanda rimasta"
            } else {
                return "\(remainingAnswers) domande rimaste"
            }
        }
    }
    func lightsImage(for game : Game) -> UIImage {
        if game.ended {
            return UIImage(named: "traffic_lights_red")!
        } else if game.my_turn {
            return UIImage(named: "traffic_lights_green")!
        } else {
            return UIImage(named: "traffic_lights_yellow")!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView.circleRounded()
    }
    
}
