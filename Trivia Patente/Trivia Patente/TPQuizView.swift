//
//  TPQuizView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 28/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPQuizView: UIViewController {
    var quiz : Quiz! {
        didSet {
            self.quizNameLabel.text = quiz.question
            self.quizImageView.load(quiz: quiz)
            self.prepareQuiz()
        }
    }
    var round : Round!
    var delegate : TPQuizViewDelegate!
    var answer : Bool?
    @IBOutlet var quizImageView : UIImageView!
    @IBOutlet var quizNameLabel : UILabel!
    @IBOutlet var trueButton : UIButton!
    @IBOutlet var falseButton : UIButton!
    let handler = SocketGame()
    @IBAction func answer(sender : UIButton) {
        let answer = (sender == trueButton)
        handler.answer(answer: answer, round: round, quiz: quiz) { response in
            if response?.success == true {
                self.enable(button: sender)
                self.delegate.user_answered(answer: answer, correct: response!.correct)
            } else {
                //TODO: handle error
            }
        }
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
        if let previousAnswer = answer {
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
    }
    func prepareView() {
        self.trueButton.circleRounded()
        self.trueButton.layer.borderWidth = 2
        self.falseButton.circleRounded()
        self.falseButton.layer.borderWidth = 2
        self.quizImageView.shadow(radius: 2)
        self.prepareQuiz()
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

