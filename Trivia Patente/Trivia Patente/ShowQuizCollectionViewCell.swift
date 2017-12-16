//
//  ShowQuizCollectionViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class ShowQuizCollectionViewCell: UICollectionViewCell {

    var quiz : Quiz! {
        didSet {
            
            self.quizNameView.text = quiz.question
            if let _ = quiz.imageId {
                self.quizImageView.load(quiz: quiz)
                self.quizNameView.textAlignment = .left
            } else {
                self.quizNameView.textAlignment = .center
            }
            self.quizImageView.isHidden = (quiz.imageId == nil)
            self.titleCostraint.priority = (quiz.imageId == nil) ? 999 : 250
            self.prepareQuiz()
        }
    }
    var round : Round!
    var delegate : ShowQuizCellDelegate!
    var defaultImageFrame : CGRect!
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    @IBOutlet var quizImageView : UIImageView! {
        didSet {
            defaultImageFrame = quizImageView.frame
        }
    }
    @IBOutlet var quizNameView : TPTextView!
    @IBOutlet var separatorView : UIView!
    @IBOutlet var trueButton : UIButton!
    @IBOutlet var falseButton : UIButton!
    @IBOutlet var shapeView : UIView!
    @IBOutlet var titleCostraint : NSLayoutConstraint!

    
    var imageExpanded = false
    func imageClicked() {
        if imageExpanded == true {
            minimizeImage()
        } else {
            expandImage()
        }
        self.imageExpanded = !self.imageExpanded
    }
    func minimizeImage() {
        if let superview = quizImageView.superview {
            UIView.animate(withDuration: 0.2, delay: 0, options: .allowAnimatedContent, animations: {
                self.quizImageView.frame = self.defaultImageFrame
                self.quizImageView.center.y = superview.frame.size.height / 2
            }, completion: { (c) in
                UIView.animate(withDuration: 0.1) {
                    self.quizNameView.alpha = 1
                }
            })
            
        }
        
    }
    func expandImage() {
        if let superview = self.quizImageView.superview {
            let dimension = superview.frame.size.height - 20
            let x = superview.frame.size.width / 2
            let y = superview.frame.size.height / 2
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowAnimatedContent, animations: {
                self.quizNameView.alpha = 0
            }, completion: { (c) in
                UIView.animate(withDuration: 0.2) {
                    self.quizImageView.frame.size = CGSize(width: dimension, height: dimension)
                    self.quizImageView.center = CGPoint(x: x, y: y)
                }
            })
        }
        
    }
    let handler = SocketGame()
    @IBAction func answer(sender : UIButton) {
        let answer = (sender == trueButton)
        self.startLoading(button: sender)
        handler.answer(answer: answer, round: round, quiz: quiz) { response in
            if response.success == true {
                self.enable(button: sender)
                self.delegate.user_answered(answer: answer, correct: response.correct)
            } else {
                // TODO: in the future give feedback somehow
                self.trueButton.isEnabled = true
                self.falseButton.isEnabled = true
            }
            self.endLoading(button: sender)
        }
    }
    func startLoading(button: UIButton) {
        self.trueButton.isEnabled = false
        self.falseButton.isEnabled = false
        button.setTitle("", for: .normal)
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: button.frame.width, height:button.frame.height)
        self.activityIndicator.startAnimating()
        button.addSubview(self.activityIndicator)
    }
    func endLoading(button: UIButton) {
        button.setTitle(button == self.trueButton ? Strings.quiz_true_button_text : Strings.quiz_false_button_text , for: UIControlState.normal)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
    func disable(button : UIButton) {
        button.layer.borderColor = Colors.primary.cgColor
        button.setTitleColor(Colors.primary, for: .normal)
        button.backgroundColor = .clear
    }
    func enable(button : UIButton) {
        let otherButton = (button == trueButton) ? falseButton : trueButton
        self.disable(button: otherButton!)
        button.layer.borderColor = Colors.primary.cgColor
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.primary
        button.isEnabled = false
        otherButton!.isEnabled = false
    }
    func prepareQuiz() {
        self.trueButton.isEnabled = true
        self.falseButton.isEnabled = true
        if self.imageExpanded {
            self.minimizeImage()
        }
        if let previousAnswer = quiz?.my_answer {
            if previousAnswer == true {
                self.disable(button: falseButton)
                self.enable(button: trueButton)
            } else {
                self.disable(button: trueButton)
                self.enable(button: falseButton)
            }
        } else {
            self.disable(button: falseButton)
            self.disable(button: trueButton)
        }
        self.endLoading(button: self.trueButton)
        self.endLoading(button: self.falseButton)
    }
    func prepareView() {
        self.trueButton.circleRounded()
        self.trueButton.layer.borderWidth = 2
        self.falseButton.circleRounded()
        self.falseButton.layer.borderWidth = 2
        self.quizImageView.shadow(radius: 1)
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        self.quizImageView.addGestureRecognizer(imageRecognizer)
        self.quizNameView.textContainerInset = .zero
        self.quizNameView.textContainer.lineFragmentPadding = 0
        self.prepareQuiz()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareView()
        self.shapeView.mediumRounded()
        // Do any additional setup after loading the view.
    }

}
