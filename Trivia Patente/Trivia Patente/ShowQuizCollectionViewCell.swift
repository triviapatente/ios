//
//  ShowQuizCollectionViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class ShowQuizCollectionViewCell: UICollectionViewCell {

    var quiz : Quiz! {
        didSet {
            
            self.quizNameView.text = quiz.question
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
    @IBOutlet var quizNameView : TPTextView!
    @IBOutlet var trueButton : UIButton!
    @IBOutlet var falseButton : UIButton!
    @IBOutlet var shapeView : UIView!
    @IBOutlet weak var mainImageHeightCostraint: NSLayoutConstraint!
    
    /* HEADER */
    @IBOutlet weak var mainHeaderLabel: UILabel!
    @IBOutlet weak var headerUserImageView: UIImageView!
    @IBOutlet weak var headerUserNameLabel: UILabel!
    @IBOutlet weak var headerRightImage: UIImageView!
    @IBOutlet weak var headerRightLabel: UILabel!
    
    /* FOOTER */
    @IBOutlet var bottomButtons : [UIButton]!
    
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
                self.delegate.user_answered(answer: answer, correct: response.correct)
            } else {
                self.trueButton.isEnabled = true
                self.falseButton.isEnabled = true
                UIViewController.showToast(text: Strings.request_timout_error, view: self.contentView)
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
    }
    func prepareView() {
        self.layer.zPosition = 10
        self.headerUserImageView.circleRounded()
        self.headerRightImage.circleRounded()
        self.trueButton.bigRounded()
        self.trueButton.layer.borderWidth = 1
        self.trueButton.layer.borderColor = Colors.light_gray.cgColor
        self.falseButton.bigRounded()
        self.falseButton.layer.borderWidth = 1
        self.falseButton.layer.borderColor = Colors.light_gray.cgColor
        self.quizImageView.shadow(radius: 1)
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        self.quizImageView.addGestureRecognizer(imageRecognizer)
        let cellPan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(gestureRecognizer:)))
        cellPan.cancelsTouchesInView = false
        self.addGestureRecognizer(cellPan)
        self.quizNameView.textContainerInset = .zero
        self.quizNameView.textContainer.lineFragmentPadding = 0
        self.prepareQuiz()
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        self.shapeView.mediumRounded()
        self.prepareView()
        
        // shadow
//        self.shapeView.shadow(radius: 1.0)
        self.shapeView.layer.shadowColor = Colors.dark_shadow.cgColor
        self.shapeView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.shapeView.layer.shadowRadius = 5.0
        self.shapeView.layer.shadowOpacity = 1.0
        self.shapeView.layer.masksToBounds = false
//        self.shapeView.layer.shadowPath = UIBezierPath(roundedRect: self.shapeView.frame, cornerRadius: self.shapeView.layer.cornerRadius).cgPath as CGPath
        
       self.loadData()
    }
    
    @IBAction func presentQuiz(sender : UIButton) {
        guard delegate != nil else { return }
        delegate.gotoQuiz(i: sender.tag)
        self.selectButton(i: sender.tag)
    }
    func selectButton(i: Int) {
        for j in 0..<bottomButtons.count {
            bottomButtons[j].shadowDeselect()
        }
        bottomButtons[i].shadowSelect()
    }

    func loadData() {
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
    
    // CARD animations
    var originalLocation : CGPoint = CGPoint.zero
    //conf
    var rotationMax = CGFloat(1.0)
    var defaultRotationAngle = CGFloat(1.0)
    var rotationStrength = CGFloat(1.0)
    var scaleMin = CGFloat(1.0)
    var animationDirection : CGFloat = 1.0
    var hasElementBehind = false
    var ausiliaryCopy : UIView?
    @IBAction func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        let xDistanceFromCenter = gestureRecognizer.translation(in: self).x
        let yDistanceFromCenter = gestureRecognizer.translation(in: self).y
        
        let touchLocation = gestureRecognizer.location(in: self)
        switch gestureRecognizer.state {
        case .began:
            // load immediatly new cell behind
            self.hasElementBehind = delegate.scroll_to_next()
            
            originalLocation = center
            
            animationDirection = touchLocation.y >= frame.size.height / 2 ? -1.0 : 1.0
            layer.shouldRasterize = true
            break
            
        case .changed:
            
            let rotationStrength = min(xDistanceFromCenter / self.frame.size.width, rotationMax)
            let rotationAngle = animationDirection * defaultRotationAngle * rotationStrength
            let scaleStrength = 1 - ((1 - scaleMin) * fabs(rotationStrength))
            let scale = max(scaleStrength, scaleMin)
            
            layer.rasterizationScale = scale * UIScreen.main.scale
            
            let transform = CGAffineTransform(rotationAngle: rotationAngle)
            let scaleTransform = transform.scaledBy(x: scale, y: scale)
            
            self.transform = scaleTransform
            center = CGPoint(x: originalLocation.x + xDistanceFromCenter, y: originalLocation.y + yDistanceFromCenter)
//            delegate?.cardDraggedWithFinishPercent(self, percent: min(fabs(xDistanceFromCenter! * 100 / frame.size.width), 100))
            
            break
        case .ended:
            panEnded(percentage: xDistanceFromCenter / frame.size.width)
            layer.shouldRasterize = false
        default :
            break
        }
    }
    
    func panEnded(percentage: CGFloat)
    {
        if abs(percentage) > PlayRoundViewController.SWIPE_DRAG_PERCENTAGE {
            if hasElementBehind {
                animateAway()
            } else {
                resetCard(animated: true)
            }
        } else {
            resetCard(animated: true)
        }
    }
    
    func resetCard(animated: Bool = true) {
        UIView.animate(withDuration: animated ? PlayRoundViewController.SWIPE_DRAG_ANIMATION_DURATION : 0) {
            self.transform = CGAffineTransform.identity
            self.center = self.originalLocation
        }
    }
    private func animateAway() {
//        UIView.animate(withDuration: 0.6, animations: {
//            let direction = self.center.x > self.originalLocation.x ? 1.0 : -1.0
//            self.center = CGPoint(x: self.originalLocation.x * CGFloat(3.5) * CGFloat(direction), y: self.center.y)
//        }) { (a) in
//            self.resetCard(animated: false)
//        }
    }
}
