//
//  WrongAnswerTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 12/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class WrongAnswerTableViewCell: TPRecentTableViewCell {
    @IBOutlet var quizImageView : UIImageView!
    @IBOutlet var questionView : UILabel!
    
    @IBOutlet var trueButton : UIButton!
    @IBOutlet var falseButton : UIButton!
    
    @IBOutlet var trueAvatar : UIImageView!
    @IBOutlet var falseAvatar : UIImageView!
    
    override var item: Base! {
        didSet {
            quiz = item as! Quiz
        }
    }
    var quiz : Quiz! {
        didSet {
            if let _ = quiz.imageId {
                //TODO: load image
            } else {
                self.quizImageView.frame.size.width = 0
            }
            self.questionView.text = quiz.question
            if quiz.answer == true {
                setEnabled(button: self.trueButton)
                setDisabled(button: self.falseButton)
                self.falseAvatar.loadAvatar(candidate: SessionManager.currentUser)
            } else {
                setDisabled(button: self.trueButton)
                setEnabled(button: self.falseButton)
                self.trueAvatar.loadAvatar(candidate: SessionManager.currentUser)
            }
            self.trueAvatar.alpha = quiz.answer ? 0 : 1
            self.falseAvatar.alpha = quiz.answer ? 1 : 0
        }
    }
    func setEnabled(button : UIButton) {
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(Colors.red_default, for: .normal)
    }
    func setDisabled(button : UIButton) {
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(.white, for: .normal)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.quizImageView.shadow(radius: 1.5)
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.trueAvatar.circleRounded()
        self.falseAvatar.circleRounded()
        self.trueButton.circleRounded()
        self.falseButton.circleRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
