//
//  PlayRoundViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 26/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD
class PlayRoundViewController: UIViewController {
    var headerView : TPGameHeader!
    var quizView : TPQuizView!
    var round : Round!
    var category : Category!
    var opponent : User!
    let handler = SocketGame()
    var selectedQuizIndex = 0
    
    @IBOutlet var bannerView : UIView!
    @IBOutlet var questionButtons : [UIButton]!
    @IBAction func presentQuiz(sender : UIButton) {
        for i in 0..<questionButtons.count {
            let button = questionButtons[i]
            if sender == button {
                selectedQuizIndex = i
                button.shadowSelect()
                self.quizView.quiz = self.questions[i]
            } else {
                button.shadowDeselect()
            }
        }
    }
    var questions : [Quiz]! {
        didSet {
            guard !questions.isEmpty else {
                return
            }
            let firstButton = questionButtons.first!
            for i in 0..<questions.count {
                let question = questions[i]
                if let my_answer = question.my_answer {
                    let correct = (my_answer == question.answer)
                    let button = self.questionButtons[i]
                    self.setQuizButtonColor(of: button, correct: correct)
                }
            }
            presentQuiz(sender: firstButton)
        }
    }
    func load() {
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        handler.get_questions(round: round) { (response : TPQuizListResponse?) in
            loadingView.hide(animated: true)
            if response?.success == true {
                self.questions = response!.questions
            }
        }
    }
    
    func setQuizButtonColor(of button : UIButton, correct : Bool? = nil) {
        if let correctness = correct {
            let color = correctness ? Colors.correct_default : Colors.error_default
            button.backgroundColor = color
        }
        button.darkerBorder(of: 0.1, width: 2)
    }
    func configureView() {
        for i in 0..<questionButtons.count {
            let button = questionButtons[i]
            button.circleRounded()
            button.shadow(radius: 4, color: .white)
            let title = "\((i + 1) * round.number!)"
            button.setTitle(title, for: .normal)
            self.setQuizButtonColor(of: button)
        }
        quizView.view.mediumRounded()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.headerView.round = round
        //TODO: set category
        self.headerView.category = category
        self.quizView.round = round

        (self.navigationController as! TPNavigationController).setUser(candidate: opponent)
        load()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "quiz_segue" {
            self.quizView = segue.destination as! TPQuizView
            self.quizView.delegate = self
        } else if segue.identifier == "header_segue" {
            self.headerView = segue.destination as! TPGameHeader
        }
    }
    func allAnswered() -> Bool {
        for question in questions {
            if question.my_answer == nil {
                return false
            }
        }
        return true
    }
    func nextQuiz() -> Int? {
        for i in 1...4 {
            let candidate = (selectedQuizIndex + i) % 4
            if self.questions[candidate].my_answer == nil {
                return candidate
            }
        }
        return nil
    }
    func roundEnded() {
        let alert = UIAlertController(title: "Round finito", message: "Il round è finito", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
extension PlayRoundViewController : TPQuizViewDelegate {
    func user_answered(answer: Bool, correct: Bool) {
        self.questions[selectedQuizIndex].my_answer = answer
        let button = self.questionButtons[selectedQuizIndex]
        self.setQuizButtonColor(of: button, correct: correct)
        if let quizIndex = nextQuiz() {
            let nextButton = self.questionButtons[quizIndex]
            self.presentQuiz(sender: nextButton)
        } else {
            self.roundEnded()
        }
    }
}
