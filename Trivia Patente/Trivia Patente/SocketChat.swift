//
//  SocketChat.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 10/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class SocketChat: SocketManager {
    func send_message(game : Game, content : String, handler : @escaping (TPMessageResponse?) -> Void) {
        SocketManager.emit(path: "send_message", values: ["content": content as AnyObject, "game_id": game.id as AnyObject], handler: handler)
    }
    func listen(handler : @escaping (TPMessageResponse?) -> Void) {
        SocketManager.listen(event: "message", handler: handler)
    }
}
