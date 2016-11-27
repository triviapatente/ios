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
            italianResponse?.limitToFit(in: self.tableView)
            checkAndAddUser(response: &italianResponse!)
            italianRankMap = self.computeMap(response: italianResponse)
            self.tableView.reloadData()
            self.tableView.tableFooterView = footerView
        }
    }
    var italianSearchResponse : TPRankSearchResponse? {
        didSet {
            italianSearchResponse?.limitToFit(in: self.tableView)
            self.tableView.reloadData()
            self.tableView.tableFooterView = footerView
        }
    }
    var friendsResponse : TPRankResponse?{
        didSet {
            friendsResponse?.limitToFit(in: self.tableView)
            checkAndAddUser(response: &friendsResponse!)
            friendsRankMap = self.computeMap(response: friendsResponse)
            self.tableView.reloadData()
            self.tableView.tableFooterView = footerView
        }
    }
    var friendsSearchResponse : TPRankSearchResponse? {
        didSet {
            friendsSearchResponse?.limitToFit(in: self.tableView)
            self.tableView.reloadData()
            self.tableView.tableFooterView = footerView
        }
    }
    func checkAndAddUser(response : inout TPRankResponse) {
        if let user = SessionManager.currentUser {
            if !response.users.contains(user) {
                response.users.append(user)
            }
        }
    }
    var searching : Bool {
        get {
            if let text = self.searchBar.text {
                return !text.isEmpty
            }
            return false
        }
    }
    
    var mode = RankMode.italian
   
    func getContextualUsers() -> [User]? {
        if searching {
            return italianSearchResponse?.users
        } else if mode == .italian {
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
    var tableHeight : CGFloat {
        let count = self.tableView(self.tableView, numberOfRowsInSection: 0)
        return CGFloat(count) * self.tableView.rowHeight
    }
    var availableFooterHeight : CGFloat {
        let margin = self.tableView.frame.origin.y - self.control.frame.size.height
        return self.view.frame.size.height - self.tableHeight - self.control.frame.size.height - self.searchBar.frame.size.height - margin
    }
    let FOOTER_MIN_HEIGHT = CGFloat(70)
    var footerFrame : CGRect {
        let height = availableFooterHeight
        if height <= FOOTER_MIN_HEIGHT {
            return .zero
        }
        return CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height)
    }
    var footerView : UIView {
        let frame = footerFrame
        if frame == .zero {
            return UIView()
        }
        let footer = UIView(frame: frame)
        let buttonWidth = CGFloat(200)
        let buttonHeight = CGFloat(40)
        let buttonX = (footer.frame.size.width - buttonWidth) / 2
        let buttonY = (footer.frame.size.height - buttonHeight) / 2
        let buttonFrame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        let button = UIButton(frame: buttonFrame)
        button.mediumRounded()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.green_default
        button.setTitle("Invita i tuoi amici", for: .normal)
        button.addTarget(self, action: #selector(goToInvitePage), for: .touchUpInside)
        footer.addSubview(button)
        return footer
    }
    func goToInvitePage() {
        print("go to invite page")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "RankTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "rank_cell")
        self.tableView.rowHeight = 50

        self.changeRankType(sender: control)

    }
    

    func search(query: String) {
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        handler.search(query: query) { (response : TPRankSearchResponse) in
            loadingView.hide(animated: true)
            if response.success == true {
                if self.mode == .italian {
                    self.italianSearchResponse = response
                } else {
                    self.friendsSearchResponse = response
                }
            } else {
                //TODO error handler
            }
        }
    }
    @IBAction func dismissSearch() {
        self.searchBar.resignFirstResponder()
    }

}
extension RankViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search(query: searchBar.text!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.tableView.reloadData()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searching {
            self.search(query: searchBar.text!)
        } else {
            self.tableView.reloadData()
        }
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
        if searching {
            cell.position = cell.user.position
        } else if cell.user!.isMe() {
            cell.position = getContextualUserPosition()!
        } else {
            cell.position = getContextualMap()!["\(cell.user.score!)"]
        }
        return cell
    }
}
