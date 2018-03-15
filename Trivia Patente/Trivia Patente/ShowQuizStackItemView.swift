//
//  ShowQuizCollectionViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class ShowQuizStackItemView: UIView {
    
//    static let QUIZ_IMAGE_HEIGHT = CGFloat(125)

    var quiz : Quiz! {
        didSet {
//            self.quizNameView.translatesAutoresizingMaskIntoConstraints = false
            self.quizNameView.text = quiz.question
//            mainTextViewHeightConstraint.constant = self.quizNameView.size
//            let size = self.quizNameView.sizeThatFits(CGSize.init(width: Double(self.quizTextContainer.frame.width), height: Double.infinity))
//            self.quizNameView.frame = CGRect(x: (self.quizTextContainer.frame.width - size.width) / 2.0, y: (self.quizTextContainer.frame.height - size.height) / 2.0, width: size.width, height: size.height)
//            self.layoutIfNeeded()
//            self.quizNameView.transform = CGAffineTransform.init(translationX: 0, y: -self.quizNameView.frame.height.divided(by: 2.0))
//            self.quizNameView.center = quizTextContainer.center
            if let _ = quiz.imageId {
                self.quizImageView.load(quiz: quiz)
                
            } else {
            }
            self.quizImageView.isHidden = (quiz.imageId == nil)
            self.prepareQuiz()
        }
    }
    var round : Round!
    var delegate : ShowQuizCellDelegate! {
        didSet {
            self.loadData()
        }
    }
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    /* MAIN */
    @IBOutlet var quizImageView : UIImageView!
    @IBOutlet var quizNameView : UITextView!
    @IBOutlet var trueButton : UIButton!
    @IBOutlet var falseButton : UIButton!
    @IBOutlet var shapeView : UIView!
    @IBOutlet weak var quizTextContainer: UIView!
    @IBOutlet weak var mainTextViewTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var mainImageHeightConstraint: NSLayoutConstraint!
    
    /* HEADER */
    @IBOutlet weak var mainHeaderLabel: UILabel!
    @IBOutlet weak var headerUserImageView: UIImageView!
    @IBOutlet weak var headerUserNameLabel: UILabel!
    @IBOutlet weak var headerRightImage: UIImageView!
    @IBOutlet weak var headerRightLabel: UILabel!
    
    
    var imageExpanded = false
    @objc func imageClicked() {
        if let d = self.delegate {
            d.presentImage(image: self.quizImageView.image, target: self.quizImageView)
        }
    }
    
    let handler = SocketGame()
    @IBAction func answer(sender : UIButton) {
        let answer = (sender == trueButton)
        self.startLoading(button: sender)
        handler.answer(answer: answer, round: round, quiz: quiz) { response in
            if response.success == true {
                self.enable(button: sender)
                self.delegate.user_answered(answer: answer, correct: response.correct, quiz: self.quiz)
            } else {
                self.trueButton.isEnabled = true
                self.falseButton.isEnabled = true
                UIViewController.showToast(text: Strings.request_timout_error, view: self)
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
        button.setTitleColor(Colors.primary, for: .normal)
        button.backgroundColor = Colors.light_button_blue
    }
    func enable(button : UIButton) {
        let otherButton = (button == trueButton) ? falseButton : trueButton
        self.disable(button: otherButton!)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.primary
        button.isEnabled = false
        otherButton!.isEnabled = false
    }
    func prepareQuiz() {
        self.trueButton.isEnabled = true
        self.falseButton.isEnabled = true
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
        loadData()
    }
    func prepareView() {
        self.headerUserImageView.circleRounded()
        self.headerRightImage.circleRounded()
        self.trueButton.bigRounded()
        self.trueButton.layer.borderWidth = 1
        self.trueButton.layer.borderColor = Colors.light_gray.cgColor
        self.falseButton.bigRounded()
        self.falseButton.layer.borderWidth = 1
        self.falseButton.layer.borderColor = Colors.light_gray.cgColor
        self.headerRightImage.layer.borderWidth = 1
        self.headerRightImage.layer.borderColor = Colors.light_gray.cgColor
//        self.quizImageView.shadow(radius: 1)
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        self.quizImageView.addGestureRecognizer(imageRecognizer)
        self.quizNameView.textContainerInset = .zero
        self.quizNameView.textContainer.lineFragmentPadding = 0
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareView()
    }

    func loadData() {
//        self.prepareQuiz()
        if let d = self.delegate {
            self.mainHeaderLabel.text = d.textForMainLabel()
            let user = d.opponentUser()
            self.headerUserImageView.load(user: user)
            self.headerUserNameLabel.text = user.displayName
            let cat = d.headerRightSideData()
            self.headerRightLabel.text = cat.hint
            self.headerRightImage.load(category: cat)
        }
    }
}
