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
        let user = SessionManager.currentUser!
        user.image = "http://www.w3schools.com/css/img_fjords.jpg"
        let game1 = Game(id: 1)
        game1.opponent = user
        game1.my_turn = true
        game1.ended = false
        
        let game2 = Game(id: 2)
        game2.opponent = user
        game2.my_turn = false
        game2.ended = false

        let game3 = Game(id: 3)
        game3.opponent = user
        game3.ended = true
        game3.my_turn = false
        
        let response = TPGameListResponse()
        response.games = [game1, game2, game3]
        handler(response)
        //self.request(url: "/game/recent", method: .get, params: nil, handler: handler)
    }
}
