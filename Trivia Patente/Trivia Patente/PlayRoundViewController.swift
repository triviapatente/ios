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
    
    @IBOutlet var bannerView : UIView!
    @IBOutlet var questionButtons : [UIButton]!
    @IBOutlet var chatButton : UIButton!
    @IBOutlet var leaveButton : UIButton!
    @IBOutlet var detailButton : UIButton!
    
    @IBAction func goToDetail() {
        
    }
    @IBAction func leaveGame() {
        
    }
    @IBAction func goToChat() {
        
    }
    @IBAction func presentQuiz(sender : UIButton) {
        for i in 0..<questionButtons.count {
            let button = questionButtons[i]
            if sender == button {
                button.shadow(radius: 12, color: .white)
                self.quizView.quiz = self.questions[i]
                self.quizView.answer = self.answers[i]
            } else {
                button.shadow(radius: 0)
            }
        }
    }
    var answers : [Bool?] = [nil, nil, nil, nil]
    var questions : [Quiz]! {
        didSet {
            let firstButton = questionButtons.first!
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
    
    func setQuizButtonBorder(of button : UIButton, color : UIColor? = nil) {
        if let newColor = color {
            button.backgroundColor = newColor
        }
        button.darkerBorder(of: 0.1, width: 2)
    }
    func configureView() {
        for i in 0..<questionButtons.count {
            let button = questionButtons[i]
            button.circleRounded()
            let title = "\((i + 1) * round.number!)"
            button.setTitle(title, for: .normal)
            self.setQuizButtonBorder(of: button)
        }
        chatButton.circleRounded()
        chatButton.darkerBorder(of: 0.10, width: 4)
        leaveButton.circleRounded()
        leaveButton.darkerBorder(of: 0.10, width: 4)
        detailButton.circleRounded()
        detailButton.darkerBorder(of: 0.10, width: 4)
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

}
extension PlayRoundViewController : TPQuizViewDelegate {
    func user_answered(answer: Bool, correct: Bool) {
        let index = self.questions.index(of: self.quizView.quiz)!
        self.answers[index] = answer
        let color = correct ? Colors.green_default : Colors.error_default
        let button = self.questionButtons[index]
        self.setQuizButtonBorder(of: button, color: color)

    }
}
