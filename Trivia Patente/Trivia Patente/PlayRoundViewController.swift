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

class PlayRoundViewController: TPGameViewController, GameControllerRequired {
    static let SWIPE_DRAG_PERCENTAGE = CGFloat(0.3)
    static let SWIPE_DRAG_ANIMATION_DURATION : TimeInterval = 0.2
    
    @IBOutlet weak var bannerView : GADBannerView!
    var stackViewController : GCStackViewController!
    var pageControl : GCPageControlView!
    var round : Round!
    var category : Category!
    var opponent : User!
    var loadingView : MBProgressHUD!
    var gameCancelled : Bool = false
    
    var imageAnimationStartView : UIView?
    
    
    var gameActions : TPGameActions! {
        didSet {
            self.game.opponent = opponent
            self.gameActions.game = game
        }
    }
    var game : Game!
    let BORDER_LENGTH = CGFloat(10)
    var currentPage : Int {
        return self.stackViewController.currentIndex
    }
    
    func segueTriggered(segue: String) {
        self.performSegue(withIdentifier: segue, sender: self)
    }
    func gotoQuiz(i : Int) {
        DispatchQueue.main.async {
            self.stackViewController.scrollTo(index : i, animated: true, fastAnimation: false);
        }
    }
    var questions : [Quiz] = [] {
        didSet {
            guard !questions.isEmpty else {
                return
            }
            self.stackViewController.reloadData()
            var unansweredIndex : Int? = nil
            for i in 0..<questions.count {
                let question = questions[i]
                if let _ = question.my_answer {
                } else if unansweredIndex == nil {
                    unansweredIndex = i
                }
            }
            self.pageControl.numberTitleOffset = getQuestionNumber(for: 0)
            DispatchQueue.main.async {
                self.pageControl.reloadData()
                self.pageControl.view.isHidden = false
                self.gotoQuiz(i: unansweredIndex != nil ? unansweredIndex! : 0)
            }
        }
    }
    func load() {
        socketHandler.get_questions(round: round) {  (response : TPQuizListResponse?) in
            guard self != nil else { return }
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.join_room()
        if game.ended {
            self.navigationController!.popToRootViewController(animated: true)
        }
//        self.navigationController!.navigationBar.layer.zPosition = -1
    }
    @IBAction func exitPlaying() {
        self.navigationController!.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: true)

//        self.navigationController!.navigationBar.layer.zPosition = 100
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.stackViewController.itemNib = UINib(nibName: "", bundle: nil)
        self.stackViewController.contentInset = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        
        self.pageControl.view.isHidden = true
        
        // AD banner load
        self.bannerView.adUnitID = Constants.BannerUnitID
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
        
        self.setDefaultBackgroundGradient()
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
        let identifier = segue.identifier
        if identifier == "wait_opponent_segue" {
            let destination = segue.destination as! WaitOpponentViewController
            destination.game = game
            destination.gameCanceled = self.gameCancelled
        } else if identifier == "game_actions" {
            self.gameActions = segue.destination as! TPGameActions
        } else if identifier == "page_control" {
            self.pageControl = segue.destination as! GCPageControlView
            self.pageControl.delegate = self
        } else if identifier == "stack_view" {
            self.stackViewController = segue.destination as! GCStackViewController
            self.stackViewController.delegate = self
            self.stackViewController.dataSource = self
            self.stackViewController.itemViewNibName = "ShowQuizStackItemView"
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
            let candidate = (self.stackViewController.currentIndex + i) % 4
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

extension PlayRoundViewController : CGPageControlDelegate {
    func customizeCellAt(index: Int, cell: PageControlCollectionViewCell) {
        cell.layer.borderColor = Colors.light_gray.cgColor
        if index < questions.count, let _ = self.questions[index].my_answer {
            cell.layer.borderColor = self.questions[index].answeredCorrectly! ? Colors.green_default.cgColor : Colors.red_default.cgColor
        }
    }
    func indexSelected(index: Int) {
        self.stackViewController.scrollTo(index: index, animated: true, propagate: false)
    }
}
extension PlayRoundViewController : GCStackViewDataSource, GCStackViewDelegate {
    func numberOfItems() -> Int {
        return self.questions.count
    }
    func configureViewForItem(itemView: UIView, index: Int) {
        if let card = itemView as? ShowQuizStackItemView {
            card.quiz = self.questions[index]
            card.round = round
            card.delegate = self
        }
    }
    func stackView(stackViewController: GCStackViewController, didDisplayItemAt index: Int) {
//        self.pageControl.setIndex(to: index, propagate: false)
        self.pageControl.view.isUserInteractionEnabled = true
    }
    func stackView(stackViewController: GCStackViewController, willDisplayItemAt index: Int) {
        self.pageControl.setIndex(to: index, propagate: false)
        self.pageControl.view.isUserInteractionEnabled = false
    }
}
extension PlayRoundViewController : CollieGalleryZoomTransitionDelegate {
    
    func zoomTransitionContainerBounds() -> CGRect {
        return self.view.frame
    }
    func zoomTransitionViewToDismissForIndex(_ index: Int) -> UIView? {
        return self.imageAnimationStartView
    }
}

extension PlayRoundViewController : ShowQuizCellDelegate {
    
    func presentImage(image: UIImage?, target: UIView) {
        if let i = image {
            self.imageAnimationStartView = target
            let picture = CollieGalleryPicture(image: i)
            let gallery = CollieGallery(pictures: [picture])
            let zoomTransition = CollieGalleryTransitionType.zoom(fromView: target, zoomTransitionDelegate: self)
            gallery.presentInViewController(self, transitionType: zoomTransition)
        }
    }
    
    
    func user_answered(answer: Bool, correct: Bool, quiz: Quiz) {
        quiz.my_answer = answer
        quiz.answeredCorrectly = correct
        if let next = nextQuiz() {
            gotoQuiz(i: next)
        } else {
            self.roundEnded()
        }
    }
    func textForMainLabel() -> String {
        return "Round \(round.number!)"
    }
    
    func headerRightSideData() -> Category {
        return category
    }
    
    func opponentUser() -> User {
        return opponent
    }
    
    func scroll_to_next() -> Bool {
        return self.stackViewController.scrollToNext()
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
