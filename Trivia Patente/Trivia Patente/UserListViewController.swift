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
    @IBOutlet var tableView : UITableView!
    @IBOutlet@objc  var control : UISegmentedControl!
    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet var connectContainerView : UIView!
    @IBOutlet var blurImageView : UIImageView!
    
    var blurImage : UIImage?
    
    var bottomActivityIndicator : UIActivityIndicatorView?
    var topRefreshControl : UIRefreshControl?
    
    func createBlurImage() {
        if let image = blurImage {
            self.blurImageView.image = image
        } else {
            DispatchQueue.main.async {
                self.blurImage = self.tableView.blur(blurRadius: 4)
                self.blurImageView.image = self.blurImage
            }
        }
    }
    
    override func needsMenu() -> Bool {
        return false
    }
    
    
    var isLinkedToFB : Bool {
        return FBManager.getInfos().hasToken == true
    }
    
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
    
    
    var listType = UserListMode.rank
    var listScope = UserListScope.italian
    var cellIdentifier : String {
        if listType == .rank {
            return "RankTableViewCell"
        }
        return "GameOpponentTableViewCell"
    }
    var controllerTitle : String? {
        if listType == .rank {
            return "Classifica"
        } else {
            return "Ricerca avversario"
        }
    }

    func getContextualUsers() -> [User]? {
        if searching {
            return italianSearchResponse?.users
        } else if listScope == .italian {
            return italianResponse?.users
        }
        return friendsResponse?.users
    }
//    func getContextualUserPosition() -> Int32? {
//        guard let response = italianResponse as? TPRankResponse else {
//            return nil
//        }
//        if listScope == .italian {
//            return response.userPosition
//        }
//        guard let newResponse = friendsResponse as? TPRankResponse else {
//            return nil
//        }
//        return newResponse.userPosition
//    }
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
        self.tableView.tableFooterView = self.footerView
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
    
    var bottomActivityEnabled = true
    
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
        self.blurImageView.isHidden = false
        self.connectContainerView.isHidden = false
        self.createBlurImage()
    }
    func hideFacebookView() {
        self.connectContainerView.isHidden = true
        self.blurImageView.isHidden = true
        self.friendsResponse?.users = []
        self.reloadTable()
    }
    func getMyPosition() -> Int32?
    {
        if let users = getContextualUsers()
        {
            if let me = users.first(where: { $0.isMe() }) {
                return me.position
            }
        }
        return nil
    }
    func getMyInternalPosition() -> Int32?
    {
        if let users = getContextualUsers()
        {
            if let me = users.first(where: { $0.isMe() }) {
                return me.internalPosition
            }
        }
        return nil
    }
    func scrollToMyPosition() {
        if let users = self.getContextualUsers()
        {
            if let index = users.index(where: { $0.isMe() }) {
                self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: UITableViewScrollPosition.middle, animated: true)
            }
        }
    }
    func hideFooterView(hide: Bool) {
        if let footer = self.tableView.tableFooterView {
            footer.isHidden = hide
        }
    }
    func loadData(forceTopList : Bool = false) {
        let loadingView = MBProgressHUD.clearAndShow(to: self.tableView, animated: true)
        self.hideFooterView(hide: true)
        self.tableView.isUserInteractionEnabled = false
        let callback = {[unowned self] (response : TPUserListResponse) in
            loadingView.hide(animated: true)
            self.hideFooterView(hide: true)
            if response.success == true {
                if self.listScope == .italian {
                    self.italianResponse = response
                    if let myPos = self.getMyInternalPosition() {
                        // First solution: shows the "stairs" only if it is not in the 20es
                        //if myPos > 20 { self.enableStairs() }
                        // Second solution: show the "stairs" only if the the user is shown in the first visible table rows
                        if myPos > self.tableView.visibleCells.count { self.enableStairs() }
                    }
                    self.scrollToMyPosition()
                } else {
                    self.friendsResponse = response
                }
            } else {
                self.handleGenericError(message: response.message, dismiss:true)
            }
            self.tableView.isUserInteractionEnabled = true
        }
        
        if self.listType == .rank {
            let t : Int32? = forceTopList ? 0 : nil
            let dir : RankDirection? = forceTopList ? RankDirection.up : nil
            rankHandler.rank(scope: self.listScope, thresold: t, direction: dir, handler: callback)
        } else {
            gameHandler.suggested(scope: self.listScope, handler: callback)
        }
    }
    @objc func loadUp() {
        // only called on rank
        let callback = {[unowned self] (response : TPUserListResponse) in
            if response.success == true {
                self.italianResponse?.users.insert(contentsOf: response.users, at: 0)
                self.tableView.refreshControl!.endRefreshing()
                self.reloadTable()
            } else {
                self.handleGenericError(message: response.message, dismiss:true)
            }
        }
        
        if self.listType == .rank {
            rankHandler.rank(scope: self.listScope, thresold: getContextualUsers()!.first!.internalPosition!, direction: .down, handler: callback)
        }
    }
    
    func loadDown(endRefreshing: @escaping (() -> Void)) {
         // only called on rank
        let callback = {[unowned self] (response : TPUserListResponse) in
            if response.success == true {
                self.italianResponse?.users.append(contentsOf: response.users)
                endRefreshing()
                self.reloadTable()
            } else {
                self.handleGenericError(message: response.message, dismiss:true)
            }
        }
        
        if self.listType == .rank {
            rankHandler.rank(scope: self.listScope, thresold: getContextualUsers()!.last!.internalPosition!, direction: .up, handler: callback)
        }
    }
    var tableHeight : CGFloat {
        let count = self.tableView(self.tableView, numberOfRowsInSection: 0)
        return CGFloat(count) * self.tableView.rowHeight
    }
    var availableFooterHeight : CGFloat {
        guard self.listType == .searchOpponent else { return 0.0 }
        let margin = self.tableView.frame.origin.y - self.control.frame.size.height
        return self.view.frame.size.height - self.tableHeight - self.control.frame.size.height - self.searchBar.frame.size.height - margin
    }
    var FOOTER_MIN_HEIGHT : CGFloat {
        guard self.listType == .searchOpponent else { return 0.0 }
        return 70.0
    }
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
        footer.backgroundColor = UIColor.clear
        let buttonWidth = CGFloat(200)
        let buttonHeight = CGFloat(40)
        let buttonX = (footer.frame.size.width - buttonWidth) / 2
        let buttonY = (footer.frame.size.height - buttonHeight) / 2
        if self.listType == .searchOpponent {
            let buttonFrame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
            let button = UIButton(frame: buttonFrame)
            button.mediumRounded()
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = Colors.green_default
            button.setTitle("Invita i tuoi amici", for: .normal)
            button.addTarget(self, action: #selector(inviteFriends), for: .touchUpInside)
            footer.addSubview(button)
    }
        if self.listType == .rank {
            self.bottomActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            self.bottomActivityIndicator!.hidesWhenStopped = true
            let indicatorCenterX = self.tableView.frame.size.width / 2
            let indicatorCenterY = self.listType == .rank ? CGFloat(50.0) : buttonY + buttonHeight + 40
            self.bottomActivityIndicator!.center = CGPoint(x: indicatorCenterX, y: indicatorCenterY)
            
            footer.addSubview(self.bottomActivityIndicator!)
        }
        return footer
    }
    @objc func inviteFriends() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shareAppLink(controller: self)
    }
    
    
    var userChosenCallback : ((User) -> Void)!
    var chosenUser : User!
    
    var stairsUp = true
    var stairsHoldMyPositionResults : [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: cellIdentifier, bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "user_cell")
        self.tableView.rowHeight = 50
        self.title = self.controllerTitle

        self.changeRankType(sender: control)
        self.setDefaultBackgroundGradient()
        self.userChosenCallback = { user in
            self.chosenUser = user
            self.performSegue(withIdentifier: "wait_opponent_segue", sender: self)
        }

        if self.listType == .rank
        {
            self.topRefreshControl = UIRefreshControl()
            self.topRefreshControl!.tintColor = UIColor.white
            self.topRefreshControl!.addTarget(self, action: #selector(loadUp), for: UIControlEvents.valueChanged)
            self.tableView.refreshControl = self.topRefreshControl
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchBar.layer.addBorder(edge: .top, color: Colors.primary, thickness: 1)
        self.searchBar.layer.addBorder(edge: .bottom, color: Colors.primary, thickness: 1)

    }
    
    func enableStairs()
    {
        if self.listType == .rank && !searching {
            self.searchBar.showsBookmarkButton = true
            self.searchBar.setImage(UIImage(named: "stairs_up"), for: .bookmark, state: UIControlState.normal)
        }
    }
    
    func directionalLoadersState(enabled: Bool) {
        self.tableView.refreshControl = enabled ? self.topRefreshControl : nil
        self.bottomActivityEnabled = enabled
    }

    func search(query: String) {
        self.dismissSearch()
        let loadingView = MBProgressHUD.clearAndShow(to: self.view, animated: true)
        let handler = {[unowned self] (response : TPUserListResponse) in
            loadingView.hide(animated: true)
            if response.success == true {
                if self.listScope == .italian {
                    self.italianSearchResponse = response
                } else {
                    self.friendsSearchResponse = response
                }
            } else {
                self.handleGenericError(message: response.message, dismiss:true)
            }
        }
        if self.listType == .rank {
            self.rankHandler.search(scope: self.listScope, query: query, handler: handler)
        } else {
            self.gameHandler.search(scope: self.listScope, query: query, handler: handler)
        }
    }
    func dismissSearch() {
        if searching {
            self.searchBar.text = searchedFor
        }
        self.searchBar.resignFirstResponder()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wait_opponent_segue" {
            let destination = segue.destination as! WaitOpponentViewController
            destination.userToInvite = chosenUser
            destination.fromInvite = true
        } else if segue.identifier == "facebook_modal" {
            (segue.destination as! FBConnectInviteViewController).delegate = self
        }
    }
    
    // MARK: handle bottom pull to refresh
    let minBottomRefreshTime : TimeInterval = 1
    var bottomIsRefreshing = false
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard self.listType == .rank && !self.bottomIsRefreshing && !self.searching && self.bottomActivityEnabled else { return }
        
        // Use this 'canLoadFromBottom' variable only if you want to load from bottom iff content > table size
        let contentSize = scrollView.contentSize.height
        let tableSize = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let canLoadFromBottom = contentSize > tableSize
        
        // Offset
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let difference = maximumOffset - currentOffset
        
        // Difference threshold as you like. -120.0 means pulling the cell up 120 points
        if canLoadFromBottom, difference <= -0.0 {
            self.bottomActivityIndicator?.startAnimating()
            let bottomRefreshShowedAt = NSDate().timeIntervalSince1970
            self.bottomIsRefreshing = true
            // Save the current bottom inset
            let previousScrollViewBottomInset = scrollView.contentInset.bottom
            // Add 50 points to bottom inset, avoiding it from laying over the refresh control.
            scrollView.contentInset.bottom = previousScrollViewBottomInset + 50
            
            let endRefreshing = {[unowned self] (timer : Timer) in
                // Reset the bottom inset to its original value
                self.bottomActivityIndicator?.stopAnimating()
                scrollView.contentInset.bottom = previousScrollViewBottomInset
                self.bottomIsRefreshing = false
            }
            
            // loadMoreData function call
            loadDown() { _ in
                print(bottomRefreshShowedAt)
                let timeDiff = NSDate().timeIntervalSince1970 - bottomRefreshShowedAt
                if timeDiff >= self.minBottomRefreshTime {
                    endRefreshing(Timer()) // useless empty timer
                } else {
                    Timer.scheduledTimer(withTimeInterval: self.minBottomRefreshTime - timeDiff, repeats: false, block: endRefreshing)
                }
            }
        }
    }
    
    var searchedFor : String?
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.dismissSearch()
    }
}

extension UserListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.characters.count > 0 {
            self.searchedFor = searchBar.text!
            self.search(query: searchBar.text!)
        }
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.reloadTable()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searching {
//            self.search(query: searchBar.text!)
            self.searchBar.showsBookmarkButton = false
            self.tableView.refreshControl = nil
        } else {
            if self.listType == .rank {
                self.searchBar.showsBookmarkButton = true
                self.tableView.refreshControl = self.topRefreshControl
            }
            self.reloadTable()
        }
    }
}
extension UserListViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func noUsersFoundLabel() -> UILabel {
        let bgLabel = UILabel()
        bgLabel.text = Strings.no_user_found + "\n\n\n\n\n" // do NEVER delete the '\n'
        bgLabel.textAlignment = .center
        bgLabel.numberOfLines = 0
        bgLabel.transform = CGAffineTransform(translationX: 0, y: -20)
        bgLabel.font = UIFont(name: "Avenir Next", size: 16.0)
        bgLabel.textColor = UIColor.white
        return bgLabel
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        self.tableView.backgroundView = nil
        self.tableView.isScrollEnabled = true
        if let list = getContextualUsers() {
            if list.count == 0 && searching {
                self.tableView.backgroundView = noUsersFoundLabel()
                self.tableView.isScrollEnabled = false
            }
            rows = list.count
        }
        self.directionalLoadersState(enabled : rows != 0)
        return rows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "user_cell")
        if let cell = reusableCell as? RankTableViewCell {
            if let users = getContextualUsers() {
                if indexPath.row < users.count {
                    cell.user = users[indexPath.row]
                    cell.position = cell.user.position
                }
            }
            
            return cell
        } else {
            let cell = reusableCell as! GameOpponentTableViewCell
            cell.userChosenCallback = self.userChosenCallback
            if let users = getContextualUsers() {
                if indexPath.row < users.count {
                    cell.user = users[indexPath.row]
                }
            }
            return cell
        }
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if self.stairsUp {
            searchBar.setImage(UIImage(named: "stairs_down"), for: .bookmark, state: .normal)
            self.stairsHoldMyPositionResults = self.getContextualUsers()
            self.loadData(forceTopList:  true)
        } else {
            searchBar.setImage(UIImage(named: "stairs_up"), for: .bookmark, state: .normal)
            self.italianResponse!.users = self.stairsHoldMyPositionResults!
            self.reloadTable()
            self.scrollToMyPosition()
            
        }
        self.stairsUp = !self.stairsUp
    }
    
}
extension UserListViewController : FBConnectInviteDelegate {
    func connected() {
        self.hideFacebookView()
        self.loadData()
    }
    func dismissed() {
        self.control.selectedSegmentIndex = 0
        self.changeRankType(sender: self.control)
    }
}
