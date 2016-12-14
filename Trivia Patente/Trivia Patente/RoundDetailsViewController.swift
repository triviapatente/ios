//
//  RoundDetailsViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class RoundDetailsViewController: UIViewController {
    var game : Game! {
        didSet {
            self.reloadData()
        }
    }
    let handler = SocketGame()
    
    var headerView : TPGameHeader!
    var scoreView : TPScoreView!
    var sectionBar : TPSectionBar!
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
            self.computeMap(candidate: response)
            game = self.response.game
            //TODO get scores from event
            self.scoreView.set(users: response.users, scores: response.scores, game: game)
            self.sectionBar.questionMap = questionMap
            self.sectionBar.game = game
            self.reloadData()

        }
    }
    var questionMap : [String: [QuizDetail]] = [:] {
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
    @IBOutlet var tableView : UITableView!
    
    var createGameCallback : ((TPNewGameResponse) -> Void)!

    func computeMap(candidate : TPRoundResponse) {
        for answer in candidate.answers {
            let number = answer.roundNumber!
            let key = "\(number)"
            if questionMap.index(forKey: key) == nil {
                questionMap[key] = []
            }
            answer.user = response.users.first(where: {$0.id == answer.userId})
            if let index = questionMap[key]!.index(where: {$0.quiz.id == answer.quizId}) {
                questionMap[key]![index].answers.append(answer)
            } else {
                let details = QuizDetail()
                details.quiz = candidate.quizzes.first(where: {$0.id == answer.quizId})
                details.answers.append(answer)
                questionMap[key]!.append(details)
            }
        }
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
    func listen() {
        handler.listen_round_ended { (response : TPRoundEndedEvent?) in
            if response?.success == true {
                self.response.categories.append(response!.category)
                self.computeMap(candidate: response!)
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
            } else {
                //TODO: error handler
            }
        }
        handler.listen_game_left(handler: cb)
        handler.listen_game_ended(handler: cb)

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
    func height(for section: Int) -> CGFloat {
        if section == self.questionMap.count {
            return END_ROW_HEIGHT
        }
        return DETAILS_ROW_HEIGHT
    }
    func rows(for section: Int) -> Int {
        if section == self.questionMap.count {
            return 1
        }
        return 4
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
        return self.height(for: indexPath.section)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let rowHeight =  self.height(for: section)
        let count = self.rows(for: section)
        return (self.tableView.frame.size.height - rowHeight * CGFloat(count)) / 2
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (game.isEnded() && section == self.questionMap.count) || section + 1 == self.questionMap.count {
            return self.tableView(tableView, heightForHeaderInSection: section)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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
            let key = "\(indexPath.section + 1)"
            cell.quizDetail = self.questionMap[key]![indexPath.row]
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
