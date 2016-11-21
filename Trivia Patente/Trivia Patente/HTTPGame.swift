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
    func invites(handler : @escaping (TPInviteListResponse) -> Void) {
        self.request(url: "/game/invites", method: .get, params: nil, handler: handler)
    }
    
    func process_invite(game_id : Int, accepted : Bool, handler : @escaping (TPInviteResponse) -> Void) {
        self.request(url: "/game/invites/\(game_id)", method: .post, params: ["accepted" : accepted], handler: handler)
    }
    
    /*func searchUser(handler : @escaping (TPOpponentListResponse) -> Void) {
        self.request(url: "/new/random", method: .post, params: nil, handler: handler)
    }*/
    
    func randomNewGame(handler : @escaping (TPNewGameResponse) -> Void) {
        self.request(url: "/game/new/random", method: .post, params: nil, handler: handler)
    }
    
    func newGame(id : Int, handler : @escaping (TPNewGameResponse) -> Void) {
        self.request(url: "/game/new", method: .post, params: ["opponent": id], handler: handler)
    }
}
