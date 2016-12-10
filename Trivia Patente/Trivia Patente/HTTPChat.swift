//
//  HTTPChat.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 09/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import Alamofire

class HTTPChat: HTTPManager {
    func get_messages(game : Game, date : Date, handler: @escaping (TPMessageListResponse) -> Void) {
        self.request(url: "/message/list/\(game.id!)", method: .get, params: ["datetime": date.iso8601], handler: handler)
    }
}
