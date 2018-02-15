//
//  RoundDetailsViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import GoogleMobileAds

class RoundDetailsViewController: TPGameViewController, GameControllerRequired {
    var game : Game! {
        didSet {
            self.reloadData()
        }
    }
    
    override var mainOnDismiss: Bool {
        return self.gameCancelled || game.ended
    }
    
    var headerView : TPGameHeader!
    var scoreView : TPScoreView!
    var sectionBar : TPSectionBar!
    var emptyView : RoundDetailsEmptyViewController!
    var gameCancelled : Bool = false
    
    var interstitial: GADInterstitial!
    
    var opponent : User {
        return self.response.users.first(where: {$0.id != SessionManager.currentUser?.id})!
    }
    var partecipation : Partecipation? {
        guard let response = self.response else {
            return nil
        }
        return response.partecipations.first(where: {$0.userId == SessionManager.currentUser?.id})!
    }
    var shouldScrollToLastSectionAfterLoad = true
    var response : TPRoundDetailsResponse! {
        didSet {
            if let nav = self.navigationController as? TPNavigationController {
                nav.setUser(candidate: opponent)
            }
            self.scoreView.set(users: response.users, game: game)
            self.scoreView.add(answers: response.answers)
            self.computeMap(quizzes: response.quizzes)
            game = self.response.game
            self.sectionBar.questionMap = questionMap
            self.sectionBar.game = game
            self.scoreView.view.isHidden = false
            self.reloadData()
            self.checkForBanner()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                self.scrollToLastSection(animated: self.shouldScrollToLastSectionAfterLoad)
            }
        }
    }
    var questionMap : [String: [Quiz]] = [:] {
        didSet {
            self.sectionBar.questionMap = questionMap
            self.reloadData()
        }
    }
    func scrollToLastSection(animated: Bool = true) {
        self.selectPage(index: self.numberOfSections(in: self.tableView) - 1, animated: animated)
    }
    func reloadData() {
        if response != nil {
            self.sectionBar.game = game
            self.tableView.reloadData()
            self.scrollViewDidEndDecelerating(self.tableView)
        }
    }
    @IBOutlet var tableView : UITableView!
    
    var createGameCallback : ((TPNewGameResponse) -> Void)!

    func computeMap(quizzes : [Quiz]) {
        self.questionMap = [:]
        for quiz in quizzes {
            let number = response.rounds.filter({$0.id == quiz.roundId}).first!.number!
            let key = "\(number)"
            if questionMap.index(forKey: key) == nil {
                questionMap[key] = []
            }
            quiz.answers = response.answers.filter({$0.quizId == quiz.id}).map { [unowned self] (question : Question) -> Question in
                question.user = self.response.users.first(where: {$0.id == question.userId})
                return question
            }
            questionMap[key]?.append(quiz)
        }
    }
    func reloadMap() {
        self.questionMap = [:]
        self.computeMap(quizzes: response.quizzes)
    }
    func join_room() {
        guard game != nil else { return }
        socketHandler.join(game_id: game.id!) { [unowned self] (joinResponse : TPResponse?) in
            if joinResponse?.success == true {
                self.shouldScrollToLastSectionAfterLoad = self.response == nil
                self.round_details()
                self.listen()
            } else {
                self.handleGenericError(message: (joinResponse?.message!)!, dismiss: true)
            }
        }
    }
    func round_details() {
        socketHandler.round_details(game_id: game.id!) { [unowned self] response in
            if response.success == true {
                self.response = response
            } else {
                self.handleGenericError(message: response.message, dismiss: true)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "header_view" {
            self.headerView = segue.destination as! TPGameHeader
        } else if segue.identifier == "score_view" {
            self.scoreView = segue.destination as! TPScoreView
        } else if segue.identifier == "section_bar" {
            self.sectionBar = segue.destination as! TPSectionBar
        } else if segue.identifier == "wait_opponent_segue" {
            let destination = segue.destination as! WaitOpponentViewController
            self.newGameResponse.game.opponent = self.newGameResponse.opponent
            destination.game = self.newGameResponse.game
            destination.fromInvite = false
            destination.join_room()
        } else if segue.identifier == "empty_view_segue" {
            self.emptyView = segue.destination as! RoundDetailsEmptyViewController
        }
    }
    let detailsCellKey = "details_cell"
    let winnerCellKey = "game_ended_cell"
    let DETAILS_ROW_HEIGHT = CGFloat(90)
    let END_ROW_HEIGHT = CGFloat(250)
    
    var newGameResponse : TPNewGameResponse!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: Constants.InterstitialUnitID)
        let request = GADRequest()
        interstitial.load(request)
        
        let cellNib = UINib(nibName: "RoundDetailsTableViewCell", bundle: .main)
        let gameEndedNib = UINib(nibName: "GameEndedTableViewCell", bundle: .main)
        self.tableView.register(cellNib, forCellReuseIdentifier: detailsCellKey)
        self.tableView.register(gameEndedNib, forCellReuseIdentifier: winnerCellKey)
        self.sectionBar.delegate = self
        self.createGameCallback = { [unowned self] response in
            if response.success {
                self.newGameResponse = response
                self.performSegue(withIdentifier: "wait_opponent_segue", sender: self)
            } else {
                self.handleGenericError(message: response.message)
            }
        }
        self.setDefaultBackgroundGradient()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.join_room()
        if game.incomplete && !gameCancelled {
            self.opponentLeftGame()
        }
    }
    func opponentLeftGame() {
        self.showToast(text: "Il tuo avversario ha abbandonato la partita, hai vinto!")
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let timer = self.bannerTimer {
            timer.invalidate()
        }
        if let nav = navigationController {
            if !nav.viewControllers.contains(self) {
                // back button was pressed
                if self.game.ended {
                    self.navigationController?.popToRootViewController(animated: animated)
                }
            }
        }
        
        super.viewWillDisappear(animated)
    }
    func height(for indexPath: IndexPath, ignoreExpanded: Bool = false) -> CGFloat {
        if indexPath.section == self.questionMap.count {
            return END_ROW_HEIGHT
        }
        guard let selectedPath = self.tableView.indexPathForSelectedRow  else {
            return DETAILS_ROW_HEIGHT
        }
        if !ignoreExpanded && (indexPath == selectedPath) {
            let cell = self.tableView(tableView, cellForRowAt: selectedPath) as! RoundDetailsTableViewCell
            let requiredHeight = cell.requiredHeight
            return max(requiredHeight, DETAILS_ROW_HEIGHT)
        } else {
            return DETAILS_ROW_HEIGHT
        }
    }
    func rows(for section: Int) -> Int {
        if section == self.questionMap.count {
            return 1
        }
        let keys = self.keys()
        let key = keys[section]
        return self.questionMap[key]!.count
    }
    func configureHeader(page : Int) {
        if page >= self.questionMap.count {
            self.headerView.roundLabel.text = "Fine"
            self.headerView.set(title: "Risultato partita")
        } else {
            let round = self.response.rounds.filter({$0.number == page + 1}).first!
            self.headerView.category = self.response.categories.filter({$0.id == round.catId}).first!
            self.headerView.roundLabel.text = "Round \(page + 1)"
        }
    }
    
    // banner
    var bannerTimer : Timer?
    func checkForBanner() {
        guard game.ended && !game.incomplete && !self.gameCancelled && !interstitial.hasBeenUsed else { return }
        
        // game is ended here
        if let lastUpdateDate = game.updatedAt
        {
            let currentTS = Date().timeIntervalSince1970
            let lastUpdateTS = lastUpdateDate.timeIntervalSince1970
            print(currentTS - lastUpdateTS)
            if currentTS - lastUpdateTS > 60
            {
                return
            }
        }
        
        self.bannerTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {[unowned self] (t) in
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        }
        
    }
}
extension RoundDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    var currentPage : Int {
        let y = self.tableView.contentOffset.y
        let height = self.tableView.bounds.size.height
        return Int(ceil(y/height))
//        if let i = self.sectionBar.tableView.indexPathForSelectedRow {
//            return i.row
//        }
//        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = currentPage
        if page < self.questionMap.count || (game.isEnded() && page == self.questionMap.count){
            self.configureHeader(page: page)
            self.sectionBar.currentPage = page
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let selectedPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedPath, animated: false)
        }
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let selectedPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedPath, animated: false)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = self.response else {
            return 0
        }
        if game.isEnded() {
            return self.questionMap.count + 1
        }
        return self.questionMap.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows(for: section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height(for: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let firstRowPath = IndexPath(row: 0, section: section)
        let rowHeight =  self.height(for: firstRowPath, ignoreExpanded: true)
        let count = self.rows(for: section)
        return (self.tableView.frame.size.height - rowHeight * CGFloat(count)) / 2
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection: section)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.beginUpdates()
        //triggers heightForRowAt: on every visible cell
        self.tableView.endUpdates()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView(tableView, didSelectRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = self.tableView.cellForRow(at: indexPath)
        if cell?.isSelected == true {
            tableView.deselectRow(at: indexPath, animated: true)
            self.tableView(tableView, didDeselectRowAt: indexPath)
            return nil
        }
        return indexPath
    }
    func keys() -> [String] {
        return self.questionMap.keys.sorted {
            return Int($0)! < Int($1)!
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == self.questionMap.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: winnerCellKey) as! GameEndedTableViewCell
            cell.game = game
            cell.isDrew = scoreView.firstScore == scoreView.secondScore
            cell.isCancelled = self.gameCancelled
            if let partecipation = self.partecipation {
                cell.scoreIncrement = partecipation.scoreIncrement
            }
            cell.createGameCallback = self.createGameCallback
            if let users = response?.users {
                cell.users = users
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCellKey) as! RoundDetailsTableViewCell
            cell.backgroundView = UIView(frame: cell.frame)
            cell.backgroundView?.backgroundColor = .clear
            cell.backgroundColor = .clear
            let keys = self.keys()
            let key = keys[indexPath.section]
            cell.quiz = self.questionMap[key]![indexPath.row]
            return cell
        }
    }
}

extension RoundDetailsViewController : TPSectionBarDelegate {
    func selectPage(index: Int) {
        selectPage(index: index, animated: true)
    }
    
    func selectPage(index: Int, animated: Bool = true) {
        if  (self.tableView.indexPathForSelectedRow == nil) || self.tableView.indexPathForSelectedRow!.row != index {
            self.sectionBar.tableView.selectRow(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .none)
        }
        if currentPage != index {
            let indexPath = IndexPath(row: 0, section: index)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
            self.configureHeader(page: index)
        }
        
    }
}
extension RoundDetailsViewController {
    
    func listen() {
        socketHandler.listen_round_started { [unowned self] (response : TPRoundStartedEvent?) in
            if response?.success == true {
                self.response.categories.append(response!.category)
                self.scoreView.add(answers: response!.answers)
                self.response.answers += response!.answers
                self.computeMap(quizzes: response!.quizzes)
            } else {
                //TODO: error handler
            }
        }
        let cb = { [unowned self] (response : TPGameEndedEvent?) in
            if response?.success == true {
                self.game.winnerId = response!.winner_id
                self.game.ended = true
                self.response.partecipations = response!.partecipations
                self.reloadData()
                self.gameCancelled = response!.canceled
                if self.game.incomplete && !self.gameCancelled {
                    self.opponentLeftGame()
                }
            } else {
                //TODO: error handler
            }
        }
        socketHandler.listen_game_left(handler: cb)
        socketHandler.listen_game_ended(handler: cb)
        socketHandler.listen_user_left_game { [unowned self] (response) in
            self.game.incomplete = true
            cb(response)
        }
        socketHandler.listen_user_answered { [unowned self] (response : TPQuestionAnsweredEvent?) in
            if let answer = response?.answer {
                self.scoreView.add(answers: [answer])
                self.response.answers.append(answer)
                let curPage = self.sectionBar.tableView.indexPathForSelectedRow
                self.reloadMap()
                self.reloadData()
                if let i = curPage {
                    self.selectPage(index: i.row , animated: false)
                }
            }
        }
        
    }
}

extension RoundDetailsViewController : GADInterstitialDelegate {
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if !self.interstitial.hasBeenUsed {
            self.interstitial.present(fromRootViewController: self)
        }
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}
