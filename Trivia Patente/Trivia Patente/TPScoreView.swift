//
//  TPScoreView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 04/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPScoreView: UIViewController {

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
    func set(users: [User], scores: [Int]) {
        self.firstAvatarView.load(user: users.first!)
        self.firstScore = scores.first!
        self.secondAvatarView.load(user: users.last!)
        self.secondScore = scores.last!
    }
    func adaptViewToScore() {
        self.firstAvatarView.layer.borderWidth = 1
        self.secondAvatarView.layer.borderWidth = 1
        self.setColor(for: self.firstAvatarView)
        self.setColor(for: self.secondAvatarView)
    }
    func setColor(for view : UIView) {
        let isFirst = (view == firstAvatarView)
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
    }
    func listen() {
        handler.listen(event: "user_answered") { response in
            if response?.success == true {
                
            } else {
                //TODO: error handling
            }
        }
    }
    func room_joined() {
        self.listen()
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