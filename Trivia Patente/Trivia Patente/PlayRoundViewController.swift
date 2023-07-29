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
import CollieGallery

class PlayRoundViewController: BasePlayViewController, GameControllerRequired {
    
    var round : Round!
    var category : Category!
    var opponent : User!
    var loadingView : MBProgressHUD!
    var gameCancelled : Bool = false
    
    override var gameActions : TPGameActions! {
        didSet {
            self.game.opponent = opponent
            self.gameActions.game = game
        }
    }
    var game : Game!
    
    
    func load() {
        socketHandler.get_questions(round: round) {  (response : TPQuizListResponse?) in
            guard self != nil else { return }
            self.loadingView.hide(animated: true)
            if response?.success == true {
                self.questions = response!.questions
                self.pageControl.numberTitleOffset = self.getQuestionNumber(for: 0)

            } else {
                self.handleGenericError(message: (response?.message!)!, dismiss: true)
            }
        }
    }
    func join_room() {
        self.loadingView = MBProgressHUD.clearAndShow(to: self.view, animated: true)
        guard round != nil else { return }
        socketHandler.join(game_id: round.gameId!) {   (joinResponse : TPResponse?) in
            guard self != nil else { return }
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
        socketHandler.init_round(game_id: game.id!) {   (response : TPInitRoundResponse?) in
            guard self != nil else { return }
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
    
    func getQuestionNumber(for i : Int) -> Int {
        return (i + 1) + (round.number! - 1) * 4
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.join_room()
        if game.ended {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navCont = self.navigationController {
            navCont.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navCont = self.navigationController {
            navCont.setNavigationBarHidden(false, animated: true)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.playDelegate = PlayRoundDelegate(vc: self)

        if round.number! == 1 {
            self.gameActions.detailButton.isHidden = true
        } else {
            self.gameActions.detailButton.isHidden = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let identifier = segue.identifier
        if identifier == "wait_opponent_segue" {
            let destination = segue.destination as! WaitOpponentViewController
            destination.game = game
            destination.gameCanceled = self.gameCancelled
        } else if identifier == "round_details" {
            if let destination = segue.destination as? RoundDetailsViewController {
                destination.game = game
                destination.gameCancelled = self.gameCancelled
            }
        }
    }

    func roundEnded() {
        self.performSegue(withIdentifier: "wait_opponent_segue", sender: self)
    }
    
    override func configureViewForItem(itemView: UIView, index: Int) {
        if let card = itemView as? ShowQuizStackItemView {
            card.quiz = self.questions[index]
            card.round = round
            card.delegate = self.playDelegate
        }
    }
    
}





extension PlayRoundViewController {
    
    
    

}

class PlayRoundDelegate : ShowQuizCellDelegate {
    
    var baseDelegate : BasePlayDelegate
    var vc : PlayRoundViewController
    
    init(vc : PlayRoundViewController) {
        self.vc = vc
        self.baseDelegate = BasePlayDelegate(vc: vc)
    }
    
    func presentImage(image: UIImage?, target: UIView) {
        self.baseDelegate.presentImage(image: image, target: target)
    }
    
    func scroll_to_next() -> Bool {
        self.baseDelegate.scroll_to_next()
    }
    
    func canAnswerQuiz(index: Int) -> Bool {
        self.baseDelegate.canAnswerQuiz(index: index)
    }
    
    func gotoQuiz(i: Int) {
        self.baseDelegate.gotoQuiz(i: i)
    }
    func user_answered(answer: Bool, correct: Bool, quiz: Quiz) {
        if let i = self.vc.questions.index(where: { $0.id! == quiz.id! }) {
            let q = self.vc.questions[i]
            q.my_answer = answer
            q.answeredCorrectly = correct
            if let next = self.vc.nextQuiz() {
                gotoQuiz(i: next)
            } else {
                self.vc.roundEnded()
            }
        }
        
    }
    func textForMainLabel() -> String {
        return "Round \(vc.round.number!)"
    }
    
    func headerRightSideData(quiz: Quiz) -> Category? {
        return vc.category
    }
    
    func opponentUser() -> User? {
        return vc.opponent
    }
    func trainMode() -> Bool {
        return false
    }
}

extension PlayRoundViewController {
    
    func listen() {
        let cb = {  (response : TPGameEndedEvent?) in
            guard self != nil else { return }
            if response?.success == true {
                self.game.winnerId = response!.winner_id
                self.game.ended = true
                self.gameCancelled = response!.canceled
                self.roundEnded()
            } else {
                //TODO: error handler
            }
        }
        socketHandler.listen_user_left_game {  (response) in
            guard self != nil else { return }
            self.game.incomplete = true
            cb(response)
        }
    }
}


