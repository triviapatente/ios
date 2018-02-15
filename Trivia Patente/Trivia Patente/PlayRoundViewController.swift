//
//  PlayRoundViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 26/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD
import GoogleMobileAds

class PlayRoundViewController: TPGameViewController, GameControllerRequired {
    var headerView : TPGameHeader!
    @IBOutlet weak var quizCollectionView : UICollectionView!
    @IBOutlet weak var bannerView : GADBannerView!
    var round : Round!
    var category : Category!
    var opponent : User!
    var selectedQuizIndex = 0
    var loadingView : MBProgressHUD!
    var gameCancelled : Bool = false
    
    
    var gameActions : TPGameActions! {
        didSet {
            self.game.opponent = opponent
            self.gameActions.game = game
        }
    }
    var game : Game!
    
    let BORDER_LENGTH = CGFloat(30)
    
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
        DispatchQueue.main.async {
            self.quizCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    var questions : [Quiz] = [] {
        didSet {
            guard !questions.isEmpty else {
                return
            }
            self.quizCollectionView.reloadData()
            var unansweredIndex : Int? = nil
            for i in 0..<questions.count {
                let question = questions[i]
                if let _ = question.my_answer {
                    let button = self.questionButtons[i]
                    self.setQuizButtonColor(of: button, correct: question.answeredCorrectly!)
                } else if unansweredIndex == nil {
                    unansweredIndex = i
                }
            }
            presentQuiz(sender: self.questionButtons[unansweredIndex != nil ? unansweredIndex! : 0])
        }
    }
    func load() {
        socketHandler.get_questions(round: round) {[unowned self] (response : TPQuizListResponse?) in
            self.loadingView.hide(animated: true)
            if response?.success == true {
                self.questions = response!.questions
            } else {
                self.handleGenericError(message: (response?.message!)!, dismiss: true)
            }
        }
    }
    func join_room() {
        self.loadingView = MBProgressHUD.clearAndShow(to: self.view, animated: true)
        guard round != nil else { return }
        socketHandler.join(game_id: round.gameId!) { [unowned self] (joinResponse : TPResponse?) in
            if joinResponse?.success == true {
//                if self.questions.isEmpty { self.load() }
//                else { self.loadingView.hide(animated: true) }
                self.load()
                self.checkGameState()
                self.listen()
            } else {
                self.handleGenericError(message: (joinResponse?.message!)!, dismiss: true)
            }
        }
    }
    func checkGameState() {
        socketHandler.init_round(game_id: game.id!) { [unowned self] (response : TPInitRoundResponse?) in
            if response?.success == true {
                if response!.ended == true {
                    self.dismiss(animated: true, completion: nil)
                }
                if let r = response!.round {
                    if r.number != self.round.number {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                self.handleGenericError(message: (response?.message!)!, dismiss: true)
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.join_room()
        if game.ended {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AD banner load
        self.bannerView.adUnitID = Constants.BannerUnitID
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
        
        configureView()
        self.setDefaultBackgroundGradient()
        self.headerView.round = round
        if round.number! == 1 {
            self.gameActions.detailButton.isHidden = true
        } else {
            self.gameActions.detailButton.isHidden = false
        }
        //TODO: set category
        self.headerView.category = category
        (self.navigationController as! TPNavigationController).setUser(candidate: opponent)
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
            destination.gameCanceled = self.gameCancelled
        } else if identifier == "game_actions" {
            self.gameActions = segue.destination as! TPGameActions
        } else if identifier == "round_details" {
            if let destination = segue.destination as? RoundDetailsViewController {
                destination.game = game
                destination.gameCancelled = self.gameCancelled
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

extension PlayRoundViewController {
    
    func listen() {
        let cb = {[unowned self] (response : TPGameEndedEvent?) in
            if response?.success == true {
                self.game.winnerId = response!.winner_id
                self.game.ended = true
                self.gameCancelled = response!.canceled
                self.roundEnded()
            } else {
                //TODO: error handler
            }
        }
        socketHandler.listen_user_left_game {[unowned self] (response) in
            self.game.incomplete = true
            cb(response)
        }
    }
}

extension PlayRoundViewController : GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
