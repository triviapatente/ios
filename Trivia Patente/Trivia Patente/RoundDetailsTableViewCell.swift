//
//  RoundDetailsTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 04/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class RoundDetailsTableViewCell: UITableViewCell {
    @IBOutlet var quizImageView : UIImageView!
    @IBOutlet var quizNameView : UILabel!
    @IBOutlet var trueValue : UILabel!
    @IBOutlet var falseValue : UILabel!
    @IBOutlet var trueImageViews : [UIImageView]!
    @IBOutlet var falseImageViews : [UIImageView]!
    
    var quizDetail : QuizDetail! {
        didSet {
            self.quiz = quizDetail.quiz
            self.questions = quizDetail.answers
        }
    }
    
    private var quiz : Quiz! {
        didSet {
            self.quizNameView.text = quiz.question
            if let _ = quiz.imageId {
                self.quizImageView.load(quiz: quiz)
            } else {
                self.quizImageView.removeFromSuperview()
            }
            self.set(label: trueValue, enabled: quiz.answer)
            self.set(label: falseValue, enabled: !quiz.answer)
        }
    }
    private var questions : [Question]! {
        didSet {
            for question in questions {
                if question.answer == quiz.answer {
                    self.addUser(user: question.user, to: &self.trueUsers)
                } else {
                    self.addUser(user: question.user, to: &self.falseUsers)
                }
            }
            self.populate(users: self.trueUsers, imageViews: trueImageViews)
            self.populate(users: self.falseUsers, imageViews: falseImageViews)
        }
    }
    var trueUsers : [User] = []
    var falseUsers : [User] = []
    
    func populate(users : [User], imageViews : [UIImageView]) {
        for i in 0..<imageViews.count {
            let imageView = imageViews[i]
            imageView.alpha = (i >= users.count) ? 0 : 1
            if imageView.alpha == 1 {
                let user = users[i]
                imageView.load(user: user)
            }
        }
    }
    func addUser(user : User, to users: inout [User]) {
        if user.isMe() {
            users.insert(user, at: 0)
        } else {
            users.append(user)
        }
    }
    func set(label : UILabel, enabled : Bool) {
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        label.textColor = (enabled ? Colors.primary : UIColor.white)
        label.backgroundColor = enabled ? UIColor.white : Colors.primary
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.quizImageView.shadow(radius: 2)
        self.trueValue.circleRounded()
        self.falseValue.circleRounded()
        for imageView in self.trueImageViews + self.falseImageViews {
            imageView.circleRounded()
        }
        // Initialization code
    }

    
}
