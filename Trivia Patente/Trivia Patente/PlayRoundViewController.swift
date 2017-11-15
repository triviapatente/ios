//
//  PlayRoundViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 26/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD
class PlayRoundViewController: TPGameViewController {
    var headerView : TPGameHeader!
    @IBOutlet var quizCollectionView : UICollectionView!
    var round : Round!
    var category : Category!
    var opponent : User!
    let handler = SocketGame()
    var selectedQuizIndex = 0
    var loadingView : MBProgressHUD!
    
    var gameActions : TPGameActions! {
        didSet {
            self.game.opponent = opponent
            self.gameActions.game = game
        }
    }
    var game : Game!
    
    let BORDER_LENGTH = CGFloat(30)
    
    @IBOutlet var bannerView : UIView!
    @IBOutlet var questionButtons : [UIButton]!
    @IBAction func presentQuiz(sender : UIButton) {
        for i in 0..<questionButtons.count {
            let button = questionButtons[i]
            if sender == button {
                selectedQuizIndex = i
                button.shadowSelect()
                gotoQuiz(i: i)
            } else {
                button.shadowDeselect()
            }
        }
    }
    var currentPage : Int {
        let x = self.quizCollectionView.contentOffset.x
        let w = self.quizCollectionView.bounds.size.width
        return Int(ceil(x/w))
    }
    
    func segueTriggered(segue: String) {
        self.performSegue(withIdentifier: segue, sender: self)
    }
    func gotoQuiz(i : Int) {
        guard i != currentPage else {
            return
        }
        let indexPath = IndexPath(item: i, section: 0)
        DispatchQueue.global(qos: .userInteractive).async {
            self.quizCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    var questions : [Quiz] = [] {
        didSet {
            guard !questions.isEmpty else {
                return
            }
            self.quizCollectionView.reloadData()
            let firstButton = questionButtons.first!
            for i in 0..<questions.count {
                let question = questions[i]
                if let _ = question.my_answer {
                    let button = self.questionButtons[i]
                    self.setQuizButtonColor(of: button, correct: question.answeredCorrectly!)
                }
            }
            presentQuiz(sender: firstButton)
        }
    }
    func load() {
        handler.get_questions(round: round) { (response : TPQuizListResponse?) in
            self.loadingView.hide(animated: true)
            if response?.success == true {
                self.questions = response!.questions
            } else {
                self.handleGenericError(message: (response?.message!)!, dismiss: true)
            }
        }
    }
    func join_room() {
        self.loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        handler.join(game_id: round.gameId!) { (joinResponse : TPResponse?) in
            if joinResponse?.success == true {
                self.load()
            } else {
                self.handleGenericError(message: (joinResponse?.message!)!, dismiss: true)
            }
        }
    }
    
    func setQuizButtonColor(of button : UIButton, correct : Bool? = nil) {
        if let correctness = correct {
            let color = correctness ? Colors.correct_default : Colors.error_default
            button.backgroundColor = color
        }
        button.darkerBorder(of: 0.1, width: 2.5)
    }
    func getQuestionNumber(for i : Int) -> Int {
        return (i + 1) + (round.number! - 1) * 4
    }
    func configureView() {
        for i in 0..<questionButtons.count {
            let button = questionButtons[i]
            button.circleRounded()
            button.shadow(radius: 4, color: .white)
            let title = "\(getQuestionNumber(for: i))"
            button.setTitle(title, for: .normal)
            self.setQuizButtonColor(of: button)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.setDefaultBackgroundGradient()
        self.headerView.round = round
        //TODO: set category
        self.headerView.category = category
        (self.navigationController as! TPNavigationController).setUser(candidate: opponent)
        self.join_room()
        let nib = UINib(nibName: "ShowQuizCollectionViewCell", bundle: .main)
        //self.quizCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "quiz_cell")
        self.quizCollectionView.register(nib, forCellWithReuseIdentifier: "quiz_cell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == "header_segue" {
            self.headerView = segue.destination as! TPGameHeader
        } else if identifier == "wait_opponent_segue" {
            let destination = segue.destination as! WaitOpponentViewController
            destination.game = game
        } else if identifier == "game_actions" {
            self.gameActions = segue.destination as! TPGameActions
        } else if identifier == "round_details" {
            if let destination = segue.destination as? RoundDetailsViewController {
                destination.game = game
            }
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
        self.performSegue(withIdentifier: "wait_opponent_segue", sender: self)
    }
    

}
extension PlayRoundViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questions.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - BORDER_LENGTH * 2, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quiz_cell", for: indexPath) as! ShowQuizCollectionViewCell
        cell.quiz = self.questions[indexPath.row]
        cell.round = round
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let size = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath())
        return (self.view.frame.size.width - size.width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) / 2
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let button = self.questionButtons[currentPage]
        self.presentQuiz(sender: button)
    }
}
extension PlayRoundViewController : ShowQuizCellDelegate {
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
