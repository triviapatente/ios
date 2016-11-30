//
//  ChooseCategoryViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class ChooseCategoryViewController: UIViewController {

    var gameHeader : TPGameHeader!
    @IBOutlet var tableView : UITableView!
    
    var game = Game(id: 15) //TODO: adapt to request
    var opponent = User(username: "pippo", id: 1, avatar: "https://avatars3.githubusercontent.com/u/7453120?v=3&s=460") //TODO: adapt to request
    
    var round : Round! {
        didSet {
            self.gameHeader.round = round
        }
    }
    let CELL_MIN_HEIGHT = CGFloat(100)
    var indexPaths : [IndexPath] {
        var output : [IndexPath] = []
        for i in 0..<categories.count {
            output.append(IndexPath(row: i, section: 0))
        }
        return output
    }
    var categories : [Category] = [] {
        didSet {
            self.tableView.rowHeight = max(self.tableView.frame.height / 5, CELL_MIN_HEIGHT)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPaths, with: .left)
            self.tableView.endUpdates()
        }
    }
    var handler = SocketGame()
    var loadingView : MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProposedCategoryTableViewCell", bundle: .main)
        self.tableView.register(nib, forCellReuseIdentifier: "category_cell")
        self.tableView.tableFooterView = UIView()
        self.title = opponent.username
        (self.navigationController as! TPNavigationController).setUser(candidate: opponent)
        join_room()
    }
    func join_room() {
        loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)

        handler.join(game_id: game.id!) { joinResponse in
            if joinResponse?.success == true {
                self.init_round()
            } else {
                self.loadingView.hide(animated: true)
                //TODO: handle error
            }
        }
    }
    func init_round() {
        self.handler.init_round(game_id: game.id!, number: 1) { roundResponse in
            if roundResponse?.success == true {
                if let round = roundResponse?.round {
                    self.round = round
                    self.get_categories(round: round)
                }
            } else {
                self.loadingView.hide(animated: true)
                //TODO: handle error
            }
        }
    }
    func get_categories(round : Round) {
        self.handler.get_categories(round: round) { categoryResponse in
            self.loadingView.hide(animated: true)
            if categoryResponse?.success == true {
                self.categories = categoryResponse!.categories
                self.performSegue(withIdentifier: "test_segue", sender: self)
            } else {
                //TODO: handler
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "header_view" {
            gameHeader = segue.destination as! TPGameHeader
        } else if segue.identifier == "play_round" {
            if let destination = segue.destination as? PlayRoundViewController {
                destination.category = self.categories[self.tableView.indexPathForSelectedRow!.row]
                destination.round = round
                destination.opponent = opponent
            }
        } else if segue.identifier == "test_segue" {
            if let destination = segue.destination as? WaitOpponentViewController {
                destination.opponent = opponent
                destination.round = round
            }
        }
    }

}

extension ChooseCategoryViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category_cell") as! ProposedCategoryTableViewCell
        cell.category = self.categories[indexPath.row]
        if indexPath.row == self.categories.count - 1 {
            cell.separatorInset = .zero
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categories[indexPath.row]
        handler.choose_category(cat: category, round: self.round) { (response : TPResponse?) in
            if response?.success == true {
                self.performSegue(withIdentifier: "play_round", sender: self)
            } else {
                self.performSegue(withIdentifier: "play_round", sender: self)
                //TODO: error handler
            }
        }
    }
}
