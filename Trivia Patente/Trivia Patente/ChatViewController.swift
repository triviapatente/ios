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
    @IBOutlet var tableView : UITableView!
    @IBOutlet var textInputView : UITextField! {
        didSet {
            self.setRightView(view: sendButton)
        }
    }
    @IBAction func dismissKeyboard() {
        self.textInputView.resignFirstResponder()
    }
    func setRightView(view : UIView) {
        let dim = self.textInputView.frame.size.height - 3
        view.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
        textInputView.rightView = view
        textInputView.rightViewMode = .always
    }
    var originalViewFrame : CGRect!
    lazy var sendButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "ic_send_white")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.primary
        button.setImage(image, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    lazy var loadingView : UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loading.startAnimating()
        return loading
    }()
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
    
    var messages : [Message] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    func scrollToLast() {
        guard !self.messages.isEmpty else {
            return
        }
        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    func sendMessage() {
        let content = textInputView.text!
        self.setRightView(view: loadingView)
        socketHandler.send_message(game: game, content: content) { response in
            self.setRightView(view: self.sendButton)
            if response?.success == true {
                self.messages.append(response!.item)
                self.scrollToLast()
                self.textInputView.text = ""
                self.sendButton.isEnabled = false
            } else {
                //TODO: error handler
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.navigationController as! TPNavigationController).setUser(candidate: game.opponent)
        self.tableView.refreshControl = refreshControl
        self.join()
        self.registerCells()
    }
    func registerCells() {
        let leftNib = UINib(nibName: "LeftMessageTableViewCell", bundle: .main)
        let rightNib = UINib(nibName: "RightMessageTableViewCell", bundle: .main)
        self.tableView.register(leftNib, forCellReuseIdentifier: "left_cell")
        self.tableView.register(rightNib, forCellReuseIdentifier: "right_cell")

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
                self.messages.append(message)
                self.scrollToLast()
            } else {
                //TODO: error handler
            }
        }
    }
    func load() {
        self.refreshControl.beginRefreshing()
        let date = self.messages.first?.createdAt ?? Date()
        HTTPHandler.get_messages(game: game, date: date) { response in
            self.refreshControl.endRefreshing()
            if response.success == true {
                let firstTime = self.messages.isEmpty
                self.messages = response.messages + self.messages
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
        return 1
    }
    func cell(for message : Message) -> MessageTableViewCell {
        let identifier = self.cellIdentifier(for: message)
        return self.tableView.dequeueReusableCell(withIdentifier: identifier) as! MessageTableViewCell
    }
    func cellIdentifier(for message : Message) -> String {
        if message.isMine() {
            return "right_cell"
        } else {
            return "left_cell"
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = self.messages[indexPath.row]
        let cell = self.cell(for: message)
        return cell.height(for: message.content!)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        let cell = self.cell(for: message)
        cell.message = message
        return cell
    }
}
extension ChatViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendButton.sendActions(for: .touchUpInside)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.sendButton.isEnabled = !textInputView.text!.isEmpty
        return true
    }
}
