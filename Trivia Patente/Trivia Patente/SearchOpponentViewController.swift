//
//  SearchOpponentViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.

import UIKit
import MBProgressHUD

class SearchOpponentViewController: UIViewController {
    
    @IBAction func changeSearchType(sender : UISegmentedControl) {
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
    
    
    var italianResponse : TPSuggestedUsersResponse? {
        didSet {
            self.tableView.reloadData()
            self.tableView.tableFooterView = footerView
        }
    }
    var italianSearchResponse : TPSearchOpponentResponse? {
        didSet {
            self.tableView.reloadData()
            self.tableView.tableFooterView = footerView
        }
    }
    var friendsResponse : TPSuggestedUsersResponse?{
        didSet {
            self.tableView.reloadData()
            self.tableView.tableFooterView = footerView
        }
    }
    var friendsSearchResponse : TPSearchOpponentResponse? {
        didSet {
            self.tableView.reloadData()
            self.tableView.tableFooterView = footerView
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
        print("GoToInvite!")
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
    let handler = HTTPGame()
    
    func loadData() {
        
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        let callback = { (response : TPSuggestedUsersResponse) in
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
            handler.suggested_users(handler: callback)
        } else {
            handler.suggested_friends(handler: callback)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "GameOpponentTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "opponent_cell")
        self.tableView.rowHeight = 50
        
        self.changeSearchType(sender: control)
        
    }
    
    func search(query: String) {
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        handler.search(type: mode, query: query) { (response : TPSearchOpponentResponse) in
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
extension SearchOpponentViewController : UISearchBarDelegate {
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
extension SearchOpponentViewController : UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "opponent_cell") as! GameOpponentTableViewCell
        cell.user = getContextualUsers()![indexPath.row]
        return cell
    }
}

