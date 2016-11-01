//
//  HTTPGame.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class HTTPGame: HTTPManager {
    func recent_games(handler : @escaping (TPGameListResponse) -> Void) {
        self.request(url: "/game/recents", method: .get, params: nil, handler: handler)
    }
}
