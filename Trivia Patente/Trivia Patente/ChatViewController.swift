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
    @IBOutlet var textInputView : UITextField!
    @IBOutlet var sendButton : UIButton!
    
    
    var game : Game!
    var opponent : User!
    
    let gameHandler = SocketGame()
    let chatHTTPHandler = HTTPChat()
    
    var messages : [Message] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.navigationController as! TPNavigationController).setUser(candidate: opponent)
        self.join()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "chat_cell")
    }
    func join() {
        gameHandler.join(game_id: game.id!) { response in
            if response?.success == true {
                
            } else {
                //TODO: error handler
            }
        }
    }
    func list() {
        let date = self.messages.first?.createdAt
        chatHTTPHandler.get_messages(game: game, date: date) { response in
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
