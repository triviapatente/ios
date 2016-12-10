//
//  ChatViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 09/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet var tableView : UITableView!
    @IBOutlet var textInputView : UITextField! {
        didSet {
            textInputView.rightView = sendButton
            textInputView.rightViewMode = .always
        }
    }
    var originalViewFrame : CGRect!
    
    var sendButton : UIButton {
        guard let rightView = textInputView.rightView else {
            let button = UIButton()
            let image = UIImage(named: "ic_send_white")?.withRenderingMode(.alwaysTemplate)
            let dim = self.textInputView.frame.size.height - 3
            button.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
            button.tintColor = Colors.primary
            button.setImage(image, for: .normal)
            button.isEnabled = false
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
            return button
        }
        return rightView as! UIButton
    }
    
    var game : Game!
    
    let gameHandler = SocketGame()
    let HTTPHandler = HTTPChat()
    let socketHandler = SocketChat()
    
    var messages : [Message] = [] {
        didSet {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    

    func sendMessage() {
        self.textInputView.resignFirstResponder()
        let content = textInputView.text!
        socketHandler.send_message(game: game, content: content) { response in
            if response?.success == true {
                self.messages.append(response!.item)
                self.textInputView.text = ""
            } else {
                //TODO: error handler
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.navigationController as! TPNavigationController).setUser(candidate: game.opponent)
        self.join()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "chat_cell")
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
        self.animateView(offset: -keyboardFrame.height)
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
            } else {
                //TODO: error handler
            }
        }
    }
    func load() {
        let date = self.messages.first?.createdAt ?? Date()
        HTTPHandler.get_messages(game: game, date: date) { response in
            if response.success == true {
                self.messages += response.messages
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chat_cell")!
        cell.textLabel?.text = self.messages[indexPath.row].content
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
