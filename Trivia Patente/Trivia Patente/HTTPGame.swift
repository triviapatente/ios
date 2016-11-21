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
    func suggested_users(handler : @escaping (TPSuggestedUsersResponse) -> Void) {
        self.request(url: "/game/users/suggested", method: .get, params: nil, handler: handler)
    }
    func suggested_friends(handler : @escaping (TPSuggestedUsersResponse) -> Void) {
        //TODO: implement this api
        //self.request(url: "/game/friends/suggested", method: .get, params: nil, handler: handler)
        let response = TPSuggestedUsersResponse(error: "", statusCode: 200)
        response.users = []
        handler(response)
    }
    func search(type : RankMode, query : String, handler : @escaping (TPSearchOpponentResponse) -> Void) {
        if type == .italian {
            self.search_user(query: query, handler: handler)
        } else {
            self.search_friend(query: query, handler: handler)
        }
    }
    func search_user(query : String, handler : @escaping (TPSearchOpponentResponse) -> Void) {
        self.request(url: "/game/users/search?query=\(query)", method: .get, params: nil, handler: handler)
    }
    func search_friend(query : String, handler : @escaping (TPSearchOpponentResponse) -> Void) {
        //TODO: implement this api
        //self.request(url: "/game/friends/search?query=\(query)", method: .get, params: nil, handler: handler)
        let response = TPSearchOpponentResponse(error: "", statusCode: 200)
        response.users = []
        handler(response)
    }
}
