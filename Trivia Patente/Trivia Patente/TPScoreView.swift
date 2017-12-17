//
//  TPScoreView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 04/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPScoreView: BaseViewController {

    @IBOutlet var firstAvatarView : UIImageView!
    @IBOutlet var secondAvatarView : UIImageView!
    @IBOutlet var firstScoreView : UILabel!
    @IBOutlet var secondScoreView : UILabel!
    
    let handler = SocketGame()
    
    var firstScore : Int = 0 {
        didSet {
            self.firstScoreView.text = "\(firstScore)"
            self.adaptViewToScore()
        }
    }
    var secondScore : Int = 0 {
        didSet {
            self.secondScoreView.text = "\(secondScore)"
            self.adaptViewToScore()
        }
    }
    var users : [User]!
    var game : Game!
    var questions : [Question] = []
    func set(users: [User], game : Game) {
        let temp = users.sorted(by: { $0.0.isMe()}) // don't know why but it dowsn't work
//        if users.first!.isMe()
        self.users = temp
        self.game = game
        self.firstAvatarView.load(user: temp.first!)
        self.secondAvatarView.load(user: temp.last!)
    }
    
    var scores : [Int] {
        var output = [Int](repeating: 0, count: self.users.count)
        for question in questions {
            if question.correct == true {
                if let index = self.users.index(where: {$0.id == question.userId}) {
                    output[index] += 1
                }
            }
        }
        return output
    }
    func add(answers : [Question]) {
        self.questions += answers
        let scores = self.scores
        self.firstScore = scores.first!
        self.secondScore = scores.last!
    }
    func adaptViewToScore() {
        self.firstAvatarView.layer.borderWidth = 2
        self.secondAvatarView.layer.borderWidth = 2
        self.setColor(for: self.firstAvatarView)
        self.setColor(for: self.secondAvatarView)
    }
    func editOpponentScore(increment : Bool) {
        
    }
    func setColor(for view : UIView) {
        let isFirst = (view == firstAvatarView)
        guard game.isNotEnded() else {
            if (game.winnerId == nil && (firstScore == secondScore)) || game.cancelled() {
                view.layer.borderColor = Colors.orange_default.cgColor
            } else if isFirst {
                view.layer.borderColor = ((game.isWinner(user: users.first!)) ? Colors.green_default : Colors.red_default).cgColor
            } else {
                view.layer.borderColor = ((game.isWinner(user: users.last!)) ? Colors.green_default : Colors.red_default).cgColor
            }
            return
        }
        if firstScore == secondScore {
            view.layer.borderColor = Colors.yellow_default.cgColor
        } else if firstScore > secondScore {
            view.layer.borderColor = ((isFirst) ? Colors.green_default : Colors.red_default).cgColor
        } else {
            view.layer.borderColor = ((isFirst) ? Colors.red_default : Colors.green_default).cgColor
        }
    }
    func prepareView() {
        self.firstAvatarView.circleRounded()
        self.secondAvatarView.circleRounded()
        self.view.mediumRounded()
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = UIColor.white.cgColor
        self.view.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
