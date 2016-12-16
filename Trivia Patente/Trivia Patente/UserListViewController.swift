//
//  RankViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 07/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class UserListViewController: TPNormalViewController {
    let isLinkedToFB : Bool = true
    
    @IBAction func changeRankType(sender : UISegmentedControl) {
        self.searchBar.resignFirstResponder()
        self.listScope = (sender.selectedSegmentIndex == 0) ? .italian : .friends
        
        if self.listScope == .friends {
            guard isLinkedToFB == true else {
                showFacebookView()
                return
            }
        }
        self.hideFacebookView()
        if (self.listScope == .italian && italianResponse != nil) || (self.listScope == .friends && friendsResponse != nil) {
            self.reloadTable()
        } else {
            self.loadData()
        }
    }
    @IBOutlet var tableView : UITableView!
    @IBOutlet var control : UISegmentedControl!
    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet var visualEffectView : UIVisualEffectView!
    var connectView : FBConnectInviteViewController! {
        didSet {
            connectView.canDismiss = false
        }
    }
    
    var listType = UserListMode.rank
    var listScope = UserListScope.italian
    var cellIdentifier : String {
        if listType == .rank {
            return "RankTableViewCell"
        }
        return "GameOpponentTableViewCell"
    }

    func getContextualUsers() -> [User]? {
        if searching {
            return italianSearchResponse?.users
        } else if listScope == .italian {
            return italianResponse?.users
        }
        return friendsResponse?.users
    }
    func getContextualUserPosition() -> Int? {
        guard let response = italianResponse as? TPRankResponse else {
            return nil
        }
        if listScope == .italian {
            return response.userPosition
        }
        guard let newResponse = friendsResponse as? TPRankResponse else {
            return nil
        }
        return newResponse.userPosition
    }
    func getContextualMap() -> [String : Int]? {
        if listScope == .italian {
            if searching {
                return (italianSearchResponse as! TPRankSearchResponse).map
            }
            return (italianResponse as! TPRankResponse).map
        } else {
            if searching {
                return (friendsSearchResponse as! TPRankSearchResponse).map
            }
            return (friendsResponse as! TPRankResponse).map
        }
    }
    var italianResponse : TPUserListResponse? {
        didSet {
            self.reloadTable()
        }
    }
    var italianSearchResponse : TPUserListResponse? {
        didSet {
            self.reloadTable()
        }
    }
    var friendsResponse : TPUserListResponse?{
        didSet {
            self.reloadTable()
        }
    }
    var friendsSearchResponse : TPUserListResponse? {
        didSet {
            self.reloadTable()
        }
    }
    func reloadTable() {
        self.tableView.reloadData()
        self.tableView.tableFooterView = footerView
    }
    
    var searching : Bool {
        get {
            if let text = self.searchBar.text {
                return !text.isEmpty
            }
            return false
        }
    }
    
    
    let rankHandler = HTTPRank()
    let gameHandler = HTTPGame()
    
    func showFacebookView() {
        self.friendsResponse = TPRankResponse(error: nil, statusCode: 200, success: true)
        let users = [User(username: "Trivia", id: -1, score: 199),
                     User(username: "Patente", id: -2, score: 198),
                     User(username: "è", id: -3, score: 197),
                     User(username: "un", id: -4, score: 196),
                     User(username: "gioco", id: -5, score: 195),
                     User(username: "fantastico,", id: -6, score: 194),
                     User(username: "come", id: -7, score: 193),
                     User(username: "gli", id: -8, score: 192),
                     User(username: "utenti", id: -9, score: 191),
                     User(username: "che", id: -10, score: 190),
                     User(username: "giocano!", id: -11, score: 189)]
        self.friendsResponse?.users = users
        self.reloadTable()

        self.visualEffectView.isHidden = false
    }
    func hideFacebookView() {
        self.visualEffectView.isHidden = true
    }
    func loadData() {
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        let callback = { (response : TPUserListResponse) in
            loadingView.hide(animated: true)
            if response.success == true {
                if self.listScope == .italian {
                    self.italianResponse = response
                } else {
                    self.friendsResponse = response
                }
            } else {
                //TODO error handler
            }
        }
        
        if self.listType == .rank {
            rankHandler.rank(scope: self.listScope, handler: callback)
        } else {
            gameHandler.suggested(scope: self.listScope, handler: callback)
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
        let height = max(availableFooterHeight, FOOTER_MIN_HEIGHT)
        return CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height)
    }
    var footerView : UIView {
        let frame = footerFrame
        if frame == .zero {
            return UIView()
        }
        let footer = UIView(frame: frame)
        footer.backgroundColor = Colors.primary
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
    
    
    var userChosenCallback : ((User) -> Void)!
    var chosenUser : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: cellIdentifier, bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "user_cell")
        self.tableView.rowHeight = 50

        self.changeRankType(sender: control)
        self.userChosenCallback = { user in
            self.chosenUser = user
            self.performSegue(withIdentifier: "wait_opponent_segue", sender: self)
        }

    }
    

    func search(query: String) {
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        let handler = { (response : TPUserListResponse) in
            loadingView.hide(animated: true)
            if response.success == true {
                if self.listScope == .italian {
                    self.italianSearchResponse = response
                } else {
                    self.friendsSearchResponse = response
                }
            } else {
                //TODO error handler
            }
        }
        if self.listType == .rank {
            self.rankHandler.search(scope: self.listScope, query: query, handler: handler)
        } else {
            self.gameHandler.search(scope: self.listScope, query: query, handler: handler)
        }
    }
    @IBAction func dismissSearch() {
        self.searchBar.resignFirstResponder()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wait_opponent_segue" {
            let destination = segue.destination as! WaitOpponentViewController
            destination.userToInvite = chosenUser
            destination.fromInvite = true
        } else if segue.identifier == "fb_connect_invite" {
            self.connectView = segue.destination as! FBConnectInviteViewController
        }
    }

}
extension UserListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search(query: searchBar.text!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.reloadTable()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searching {
            self.search(query: searchBar.text!)
        } else {
            self.reloadTable()
        }
    }
}
extension UserListViewController : UITableViewDelegate, UITableViewDataSource {
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
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "user_cell")
        if let cell = reusableCell as? RankTableViewCell {
            cell.user = getContextualUsers()![indexPath.row]
            if searching {
                cell.position = cell.user.position
            } else if cell.user!.isMe() {
                cell.position = getContextualUserPosition()!
            } else {
                cell.position = getContextualMap()!["\(cell.user.score!)"]
            }
            cell.user = getContextualUsers()![indexPath.row]
            return cell
        } else {
            let cell = reusableCell as! GameOpponentTableViewCell
            cell.userChosenCallback = self.userChosenCallback
            cell.user = getContextualUsers()![indexPath.row]
            return cell
        }
    }
}
