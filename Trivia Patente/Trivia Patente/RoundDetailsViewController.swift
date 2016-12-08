//
//  RoundDetailsViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class RoundDetailsViewController: UIViewController {
    var game : Game!
    let handler = SocketGame()
    
    var headerView : TPGameHeader!
    var scoreView : TPScoreView!
    var opponent : User {
        return self.response.users.first(where: {$0.id != SessionManager.currentUser?.id})!
    }
    var response : TPRoundDetailsResponse! {
        didSet {
            (self.navigationController as! TPNavigationController).setUser(candidate: opponent)
            game.winnerId = response.users.last?.id
            self.computeMap()
            self.scoreView.set(users: response.users, scores: response.scores)
            self.tableView.reloadData()
            self.scrollViewDidEndDecelerating(self.tableView)
        }
    }
    var questionMap : [String: [QuizDetail]] = [:]
    @IBOutlet var tableView : UITableView!
    
    var createGameCallback : ((TPNewGameResponse) -> Void)!

    func computeMap() {
        for answer in response.answers {
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
                details.quiz = response.quizzes.first(where: {$0.id == answer.quizId})
                details.answers.append(answer)
                questionMap[key]!.append(details)
            }
        }
    }
    func join_room() {
        handler.join(game_id: game.id!) { (joinResponse : TPResponse?) in
            if joinResponse?.success == true {
                self.round_details()
            } else {
                //TODO: handle error
            }
        }
    }
    func round_details() {
        handler.round_details(game_id: game.id!) { response in
            if response?.success == true {
                self.scoreView.room_joined()
                self.response = response
            } else {
                //TODO: error handler
            }
        }
    }
    func listen() {
        handler.listen(event: "round_ended") { response in
            if response?.success == true {
                
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
}
extension RoundDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    var currentPage : Int {
        let x = self.tableView.contentOffset.x
        let w = self.tableView.bounds.size.width
        return Int(ceil(x/w))
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.headerView.category = self.response.categories[currentPage]
        if currentPage == self.questionMap.count {
            self.headerView.roundLabel.text = "Fine"
        } else {
            self.headerView.roundLabel.text = "Round \(currentPage + 1)"
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
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
            cell.scoreIncrement = -59
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
