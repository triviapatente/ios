//
//  QuizQuestionTableViewCell.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 09/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class QuizQuestionTableViewCell: UITableViewCell {
    static let imageWidth  = CGFloat(50)
    @IBOutlet weak var questionImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var trueValue: UILabel!
    @IBOutlet weak var falseValue: UILabel!
    var parentController : QuizDetailsViewController!
    
    
    var tapRecognizer : UITapGestureRecognizer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.trueValue.circleRounded()
        self.falseValue.circleRounded()
        if tapRecognizer == nil {
            tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagePressed))
            quizImageView.addGestureRecognizer(tapRecognizer!)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setQuestion(question: Quiz) {
        self.questionImageWidthConstraint.constant = 0.0
        if question.imageId != nil {
            // has imaage
            self.quizImageView.load(quiz: question)
            self.questionImageWidthConstraint.constant = QuizQuestionTableViewCell.imageWidth

        }
        self.mainLabel.text = question.question!
        self.set(label: self.trueValue, selected: false)
        self.set(label: self.falseValue, selected: false)
        
        if let user_answer = question.my_answer {
            self.set(label: user_answer ? self.trueValue : self.falseValue, selected: true)
        }
        question.answeredCorrectly = question.answer! == question.my_answer
        
        self.answered(correct: question.answeredCorrectly!)
    }
    
    func answered(correct: Bool) {
        self.backgroundColor = correct ? UIColor.clear : Colors.passive_red
    }
    
    func set(label : UILabel, selected : Bool) {
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        label.textColor = (selected ? Colors.primary : UIColor.white)
        label.backgroundColor = selected ? UIColor.white : UIColor.clear
    }
    
    @objc func imagePressed() {
        parentController.imageAnimationStartView = self.quizImageView
        parentController.presentImage(image: self.quizImageView.image!)
    }
}
