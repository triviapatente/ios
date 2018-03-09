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
    
    func setQuestion(question: Int) {
        self.questionImageWidthConstraint.constant = 0.0
        if question%2 == 0 {
            // has imaage
//            self.quizImageView.load()
            self.questionImageWidthConstraint.constant = QuizQuestionTableViewCell.imageWidth
            self.mainLabel.text = self.mainLabel.text! + " fheui hfurie hfuire fuire hfui reuifh reuif huier fuierh fuireh fuier hfuihr euifh reuifhreui gyutrh"
        }
        self.set(label: self.trueValue, selected: question%2 == 0)
        self.set(label: self.falseValue, selected: question%2 != 0)
        
        self.answered(correct: question != 2)
//        self.mainLabel.text = ""
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
