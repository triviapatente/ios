//
//  RoundDetailsViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class RoundDetailsViewController: TPGameViewController {
    var game : Game! {
        didSet {
            self.reloadData()
        }
    }
    
    //not returning to main on dismiss, but on PlayRoundViewController/WaitOpponentViewController
    override var mainOnDismiss: Bool {
        return false
    }
    
    let handler = SocketGame()
    
    var headerView : TPGameHeader!
    var scoreView : TPScoreView!
    var sectionBar : TPSectionBar!
    var emptyView : RoundDetailsEmptyViewController!
    var opponent : User {
        return self.response.users.first(where: {$0.id != SessionManager.currentUser?.id})!
    }
    var partecipation : Partecipation? {
        guard let response = self.response else {
            return nil
        }
        return response.partecipations.first(where: {$0.userId == SessionManager.currentUser?.id})!
    }
    var response : TPRoundDetailsResponse! {
        didSet {
            (self.navigationController as! TPNavigationController).setUser(candidate: opponent)
            self.scoreView.set(users: response.users, game: game)
            self.scoreView.add(answers: response.answers)
            self.computeMap(quizzes: response.quizzes)
            game = self.response.game
            self.sectionBar.questionMap = questionMap
            self.sectionBar.game = game
            self.decideToShowEmptyView()
            self.reloadData()

        }
    }
    var questionMap : [String: [Quiz]] = [:] {
        didSet {
            self.sectionBar.questionMap = questionMap
            self.reloadData()
        }
    }
    func reloadData() {
        if response != nil {
            self.sectionBar.game = game
            self.tableView.reloadData()
            self.scrollViewDidEndDecelerating(self.tableView)
        }
    }
    func decideToShowEmptyView() {
        self.tableView.isHidden = questionMap.isEmpty && !game.ended
        self.emptyContainer.isHidden = !self.tableView.isHidden
        if self.tableView.isHidden {
            self.headerView.roundLabel.text = "Partita"
            self.headerView.set(title: "Devi ancora iniziare!")
            self.emptyView.set(opponent: opponent, increment: response.scoreIncrement)
        }
    }
    @IBOutlet var tableView : UITableView!
    @IBOutlet var emptyContainer : UIView!
    
    var createGameCallback : ((TPNewGameResponse) -> Void)!

    func computeMap(quizzes : [Quiz]) {
        for quiz in quizzes {
            let number = quiz.roundId!
            let key = "\(number)"
            if questionMap.index(forKey: key) == nil {
                questionMap[key] = []
            }
            quiz.answers = response.answers.filter({$0.quizId == quiz.id}).map { (question : Question) -> Question in
                question.user = self.response.users.first(where: {$0.id == question.userId})
                return question
            }
            questionMap[key]?.append(quiz)
        }
    }
    func reloadMap() {
        self.computeMap(quizzes: response.quizzes)
    }
    func join_room() {
        handler.join(game_id: game.id!) { (joinResponse : TPResponse?) in
            if joinResponse?.success == true {
                self.round_details()
                self.listen()
            } else {
                //TODO: handle error
            }
        }
    }
    func round_details() {
        handler.round_details(game_id: game.id!) { response in
            if response?.success == true {
                self.response = response
            } else {
                //TODO: error handler
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
            destination.fromInvite = true
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
        self.join_room()
        let cellNib = UINib(nibName: "RoundDetailsTableViewCell", bundle: .main)
        let gameEndedNib = UINib(nibName: "GameEndedTableViewCell", bundle: .main)
        self.tableView.register(cellNib, forCellReuseIdentifier: detailsCellKey)
        self.tableView.register(gameEndedNib, forCellReuseIdentifier: winnerCellKey)
        self.sectionBar.delegate = self
        self.createGameCallback = { response in
            self.newGameResponse = response
            self.performSegue(withIdentifier: "wait_opponent_segue", sender: self)
        }
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
        let keys = self.questionMap.keys.sorted()
        let key = keys[section]
        return self.questionMap[key]!.count
    }
    func configureHeader(page : Int) {
        if page >= self.questionMap.count {
            self.headerView.roundLabel.text = "Fine"
            self.headerView.set(title: "Risultato partita")
        } else {
            self.headerView.category = self.response.categories[page]
            self.headerView.roundLabel.text = "Round \(page + 1)"
        }
    }
}
extension RoundDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    var currentPage : Int {
        let y = self.tableView.contentOffset.y
        let height = self.tableView.bounds.size.height
        return Int(ceil(y/height))
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = currentPage
        if page < self.questionMap.count || (game.isEnded() && page == self.questionMap.count){
            self.configureHeader(page: page)
            self.sectionBar.currentPage = page
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == self.questionMap.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: winnerCellKey) as! GameEndedTableViewCell
            cell.game = game
            if let partecipation = self.partecipation {
                cell.scoreIncrement = partecipation.scoreIncrement
            }
            cell.createGameCallback = self.createGameCallback
            if let users = response?.users {
                cell.users = users
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCellKey) as! RoundDetailsTableViewCell
            cell.backgroundView = UIView(frame: cell.frame)
            cell.backgroundView?.backgroundColor = Colors.primary
            cell.backgroundColor = .clear
            let keys = self.questionMap.keys.sorted()
            let key = keys[indexPath.section]
            cell.quiz = self.questionMap[key]![indexPath.row]
            return cell
        }
    }
}

extension RoundDetailsViewController : TPSectionBarDelegate {
    func selectPage(index: Int) {
        if currentPage != index {
            let indexPath = IndexPath(row: 0, section: index)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            self.configureHeader(page: index)
        }
    }
}
extension RoundDetailsViewController {
    
    func listen() {
        handler.listen_round_started { (response : TPRoundStartedEvent?) in
            if response?.success == true {
                self.response.categories.append(response!.category)
                self.scoreView.add(answers: response!.answers)
                self.response.answers += response!.answers
                self.computeMap(quizzes: response!.quizzes)
                self.decideToShowEmptyView()
            } else {
                //TODO: error handler
            }
        }
        let cb = { (response : TPGameEndedEvent?) in
            if response?.success == true {
                self.game.winnerId = response!.winner_id
                self.game.ended = true
                self.response.partecipations = response!.partecipations
                self.reloadData()
                self.decideToShowEmptyView()
            } else {
                //TODO: error handler
            }
        }
        handler.listen_game_left(handler: cb)
        handler.listen_game_ended(handler: cb)
        handler.listen_user_answered { (response : TPQuestionAnsweredEvent?) in
            if let answer = response?.answer {
                self.scoreView.add(answers: [answer])
                self.response.answers.append(answer)
                self.reloadMap()
            }
        }
        
    }
}
