//
//  RankViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 07/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class RankViewController: UIViewController {
    
    @IBAction func changeRankType(sender : UISegmentedControl) {
        self.searchBar.resignFirstResponder()
        self.mode = (sender.selectedSegmentIndex == 0) ? .italian : .friends
        if (self.mode == .italian && italianResponse != nil) || (self.mode == .friends && friendsResponse != nil) {
            self.tableView.reloadData()
        } else {
            self.loadData()
        }
    }
    @IBOutlet var tableView : UITableView!
    @IBOutlet var control : UISegmentedControl!
    @IBOutlet var searchBar : UISearchBar!
    
    var italianRankMap : [String : Int]?
    var friendsRankMap : [String : Int]?

    func computeMap(response : TPRankResponse?) -> [String : Int]? {
        if let users = response?.users {
            var output : [String : Int] = [:]
            var lastScore = -1
            var currentPosition = 1
            for user in users {
                if user.score != lastScore {
                    lastScore = user.score!
                    output["\(lastScore)"] = currentPosition
                    currentPosition += 1
                }
            }
            return output
        }
        return nil
    }
    var italianResponse : TPRankResponse? {
        didSet {
            checkAndAddUser(response: &italianResponse!)
            italianRankMap = self.computeMap(response: italianResponse)
            self.tableView.reloadData()
        }
    }
    var friendsResponse : TPRankResponse?{
        didSet {
            checkAndAddUser(response: &friendsResponse!)
            friendsRankMap = self.computeMap(response: friendsResponse)
            self.tableView.reloadData()
        }
    }
    func checkAndAddUser(response : inout TPRankResponse) {
        if let user = SessionManager.currentUser {
            if !response.users.contains(user) {
                response.users.append(user)
            }
        }
    }
    var mode = RankMode.italian
    
    func getContextualUsers() -> [User]? {
        if mode == .italian {
            return italianResponse?.users
        }
        return friendsResponse?.users
    }
    func getContextualUserPosition() -> Int? {
        if mode == .italian {
            return italianResponse?.userPosition
        }
        return friendsResponse?.userPosition
    }
    func getContextualMap() -> [String : Int]? {
        if mode == .italian {
            return italianRankMap
        }
        return friendsRankMap
    }
    
    
    let handler = HTTPRank()
    
    
    func loadData() {
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        let callback = { (response : TPRankResponse) in
            loadingView.hide(animated: true)
            if response.success == true {
                if self.mode == .italian {
                    self.italianResponse = response
                } else {
                    self.friendsResponse = response
                }
            } else {
                //TODO error handler
            }
        }
        if self.mode == .italian {
            handler.italian_rank(handler: callback)
        } else {
            handler.friends_rank(handler: callback)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "RankTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "rank_cell")
        
        self.changeRankType(sender: control)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

}

extension RankViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = getContextualUsers() {
            return list.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rank_cell") as! RankTableViewCell
        cell.user = getContextualUsers()![indexPath.row]
        if cell.user!.isMe() {
            cell.position = getContextualUserPosition()!
        } else {
            cell.position = getContextualMap()!["\(cell.user.score!)"]
        }
        return cell
    }
}
