//
//  ChatViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 09/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class ChatViewController: TPGameViewController {
    //not returning to main on dismiss, but on PlayRoundViewController/WaitOpponentViewController
    override var mainOnDismiss: Bool {
        return false
    }
    let MAX_NUMBER_OF_GROW_LINES = 5
    @IBOutlet var tableView : UITableView!
    @IBOutlet var textInputView : UITextView!
    @IBOutlet var inputViewHeight : NSLayoutConstraint!
    @IBAction func dismissKeyboard() {
        self.textInputView.resignFirstResponder()
    }
    var originalViewFrame : CGRect!
    
    static let accessorySize = CGSize(width: 40, height: 40)
    
    @IBOutlet var loadingView : UIActivityIndicatorView! {
        didSet {
            loadingView.startAnimating()
            loadingView.isHidden = true
        }
    }
    @IBOutlet var accessoryView : UIView!
    @IBOutlet var inputBarView : UIView!
    @IBOutlet var sendButton : UIButton! {
        didSet {
            let image = UIImage(named: "ic_send_white")?.withRenderingMode(.alwaysTemplate)
            self.sendButton.setImage(image, for: .normal)
            self.sendButton.isEnabled = false
        }
    }
    var refreshControl : UIRefreshControl {
        guard let output = self.tableView.refreshControl else {
            let control = UIRefreshControl()
            control.tintColor = .white
            let attributes = [NSForegroundColorAttributeName: UIColor.white]
            control.attributedTitle = NSAttributedString(string: "Caricamento..", attributes: attributes)
            control.addTarget(self, action: #selector(load), for: .valueChanged)
            return control
        }
        return output
    }
    
    var game : Game!
    
    let gameHandler = SocketGame()
    let HTTPHandler = HTTPChat()
    let socketHandler = SocketChat()
    
    var response = TPMessageListResponse(error: nil, statusCode: 200, success: true) {
        didSet {
            self.tableView.reloadData()
        }
    }
    var cachedMessages : [Message] {
        set {
            self.response.messages = newValue
            self.tableView.reloadData()
        }
        get {
            return self.response.messages
        }
    }
    
    func scrollToLast() {
        guard !self.response.map.isEmpty else {
            return
        }
        let map = self.response.map
        let lastKey = map.keys.sorted().last!
        let lastRow = map[lastKey]!.count - 1
        let lastSection = map.count - 1
        let indexPath = IndexPath(row: lastRow, section: lastSection)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

    @IBAction func sendMessage() {
        let content = textInputView.text!
        self.sendButton.isHidden = true
        self.loadingView.isHidden = false
        socketHandler.send_message(game: game, content: content) { response in
            self.loadingView.isHidden = true
            self.sendButton.isHidden = false
            if response?.success == true {
                self.cachedMessages.append(response!.item)
                self.scrollToLast()
                self.clearInputView()
                self.sendButton.isEnabled = false
            } else {
                //TODO: error handler
            }
        }
        
    }
    func clearInputView() {
        self.textInputView.text = ""
        self.textViewDidChange(textInputView)
    }
    let HEADER_HEIGHT = CGFloat(50)
    var inputInitialHeight : CGFloat!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.navigationController as! TPNavigationController).setUser(candidate: game.opponent)
        self.tableView.refreshControl = refreshControl
        self.inputInitialHeight = inputViewHeight.constant
        self.textInputView.smallRounded()
        self.accessoryView.smallRounded()
        self.join()
        self.registerCells()
    }
    func registerCells() {
        let leftNib = UINib(nibName: "LeftMessageTableViewCell", bundle: .main)
        let rightNib = UINib(nibName: "RightMessageTableViewCell", bundle: .main)
        let headerNib = UINib(nibName: "HeaderTableViewCell", bundle: .main)
        self.tableView.register(leftNib, forCellReuseIdentifier: "left_cell")
        self.tableView.register(rightNib, forCellReuseIdentifier: "right_cell")
        self.tableView.register(headerNib, forCellReuseIdentifier: "header_cell")

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.keyboardHandlers()
        self.originalViewFrame = self.view.frame
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    func keyboardHandlers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func animateView(offset : CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.size.height += offset
        }
    }
    func keyboardWillShow(notification : NSNotification) {
        let keyboardFrame = notification.keyboardFrame(in: self.view)!
        if self.view.frame.height == originalViewFrame.height {
            self.animateView(offset: -keyboardFrame.height)
        }
    }
    func keyboardWillHide(notification : NSNotification) {
        let offset = self.originalViewFrame.height - self.view.frame.height
        self.animateView(offset: offset)
    }
    func join() {
        gameHandler.join(game_id: game.id!) { response in
            if response?.success == true {
                self.load()
                self.listen()
            } else {
                //TODO: error handler
            }
        }
    }
    func listen() {
        socketHandler.listen { response in
            if let message = response?.item {
                self.cachedMessages.append(message)
                self.scrollToLast()
            } else {
                //TODO: error handler
            }
        }
    }
    func load() {
        self.refreshControl.beginRefreshing()
        let date = self.cachedMessages.first?.updatedAt ?? Date()
        HTTPHandler.get_messages(game: game, timestamp: date.timeIntervalSince1970) { response in
            self.refreshControl.endRefreshing()
            if response.success == true {
                let firstTime = self.cachedMessages.isEmpty
                let newerMessages = self.cachedMessages
                self.response = response
                self.cachedMessages += newerMessages
                if firstTime {
                    self.scrollToLast()
                }
            } else {
                //TODO: error handler
            }
        }
    }
    
}
extension ChatViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.response.map.count
    }
    func cell(for message : Message?) -> UITableViewCell {
        let identifier = self.cellIdentifier(for: message)
        return self.tableView.dequeueReusableCell(withIdentifier: identifier)!
    }
    func message(for indexPath : IndexPath) -> Message? {
        //in caso di row = 0, serve un header non un message
        guard indexPath.row != 0 else {
            return nil
        }
        let map = self.response.map
        let key = map.keys.sorted()[indexPath.section]
        return map[key]![indexPath.row - 1]
    }
    func cellIdentifier(for theMessage : Message?) -> String {
        guard let message = theMessage else {
            return "header_cell"
        }
        if message.isMine() {
            return "right_cell"
        } else {
            return "left_cell"
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = self.message(for: indexPath)
        let cell = self.cell(for: message)
        if let messageCell = cell as? MessageTableViewCell {
            return messageCell.height(for: message!.content!)
        } else {
            return HEADER_HEIGHT
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let map = self.response.map
        let key = map.keys.sorted()[section]
        return map[key]!.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.message(for: indexPath)
        let cell = self.cell(for: message)
        if let messageCell = cell as? MessageTableViewCell {
            messageCell.message = message
        } else if let headerCell = cell as? HeaderTableViewCell {
            headerCell.date = self.response.map.keys.sorted()[indexPath.section]
        }
        return cell
    }
}
extension ChatViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && range.location + range.length == textView.text.characters.count {
            self.sendButton.sendActions(for: .touchUpInside)
            return false
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        self.sendButton.isEnabled = !textInputView.text!.isEmpty
        let height = max(inputInitialHeight, self.textInputView.requiredHeight(for: MAX_NUMBER_OF_GROW_LINES))
        inputViewHeight.constant = height
        self.view.layoutIfNeeded()
    }
}
