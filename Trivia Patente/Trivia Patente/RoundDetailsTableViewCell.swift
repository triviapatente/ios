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
    
    @IBOutlet var titleCostraint : NSLayoutConstraint!
    
    
    func initializeImageViews() {
        for imageView in self.trueImageViews + self.falseImageViews {
            imageView.image = nil
            imageView.clear()
        }
    }
    var requiredHeight : CGFloat {
        return self.quizNameView.requiredHeight + self.quizNameView.frame.origin.y * 2
    }
    
    
    var quiz : Quiz! {
        didSet {
            self.initializeImageViews()
            self.questions = quiz.answers
            self.quizNameView.text = quiz.question
            if let _ = quiz.imageId {
                self.quizImageView.load(quiz: quiz)
                self.quizImageView.isHidden = false
            } else {
                self.quizImageView.isHidden = true
            }
            self.quizImageView.isHidden = (quiz.imageId == nil)
            self.titleCostraint.priority = .init(quiz.imageId == nil ? 999 : 250)
            if quiz.imageId != nil {
                self.quizNameView.frame.size.width -= self.quizImageView.frame.size.width
            }
            if let answer = quiz.answer {
                self.set(label: trueValue, enabled: answer)
                self.set(label: falseValue, enabled: !answer)
            } else {
                self.set(label: trueValue, enabled: false)
                self.set(label: falseValue, enabled: false)
            }
        }
    }
    func answer(for quiz : Quiz, answer : Question) -> Bool? {
        guard let correctAnswer = quiz.answer else {
            return nil
        }
        return answer.correct! ? correctAnswer : !correctAnswer
    }
    private var questions : [Question]! {
        didSet {
            var trueUsers : [User] = [],
                falseUsers : [User] = []
            for question in questions {
                if let answer = self.answer(for: quiz, answer: question) {
                    if answer == true {
                        self.add(user: question.user, to: &trueUsers)
                    } else {
                        self.add(user: question.user, to: &falseUsers)
                    }
                }
            }
            self.populate(users: trueUsers, imageViews: trueImageViews)
            self.populate(users: falseUsers, imageViews: falseImageViews)
        }
    }
    
    func populate(users : [User], imageViews : [UIImageView]) {
        for i in 0..<imageViews.count {
            let imageView = imageViews[i]
            if (i < users.count) {
                let user = users[i]
                imageView.load(user: user)
            }
        }
    }
    func add(user : User, to users: inout [User]) {
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
        label.alpha = enabled ? 1.0 : 0.5
        label.backgroundColor = enabled ? UIColor.white : UIColor.clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.quizImageView.shadow(radius: 1, color: Colors.dark_shadow)
        
        for label in [self.trueValue, self.falseValue] {
            label!.circleRounded()
        }
        self.backgroundColor = UIColor.clear
        for imageView in self.trueImageViews + self.falseImageViews {
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = CGFloat(1)
            imageView.circleRounded()
        }
    }

    
}
