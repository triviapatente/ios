//
//  HTTPGame.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import Alamofire

class HTTPGame: HTTPManager {
    func recent_games(handler : @escaping (TPGameListResponse) -> Void) {
        _ = self.request(url: "/game/recents", method: .get, params: nil, handler: handler)
    }
    func invites(handler : @escaping (TPInviteListResponse) -> Void) {
        _ = self.request(url: "/game/invites", method: .get, params: nil, handler: handler)
    }
    
    func process_invite(game_id : Int32, accepted : Bool, handler : @escaping (TPInviteResponse) -> Void) {
        _ = self.request(url: "/game/invites/\(game_id)", method: .post, params: ["accepted" : accepted], handler: handler)
    }
    
    /*func searchUser(handler : @escaping (TPOpponentListResponse) -> Void) {
        self.request(url: "/new/random", method: .post, params: nil, handler: handler)
    }*/
    
    func get_leave_decrement(game_id : Int32, handler : @escaping (TPLeaveDecrementResponse) -> Void) {
        _ = self.request(url: "/game/leave/decrement", method: .get, params: ["game_id": game_id], handler: handler)
    }
    func leave_game(game_id : Int32, handler : @escaping (TPResponse) -> Void) {
        _ = self.request(url: "/game/leave", method: .post, params: ["game_id": game_id], handler: handler)
    }
    
    func randomNewGame(handler : @escaping (TPNewGameResponse) -> Void) {
        _ = self.request(url: "/game/new/random", method: .post, params: nil, handler: handler)
    }
    
    func newGame(id : Int32, handler : @escaping (TPNewGameResponse) -> Void) {
        _ = self.request(url: "/game/new", method: .post, params: ["opponent": id], handler: handler)
    }
    func suggested_users(handler : @escaping (TPUserListResponse) -> Void) {
        _ = self.request(url: "/game/users/suggested", method: .get, params: nil, handler: handler)
    }
    func suggested_friends(handler : @escaping (TPUserListResponse) -> Void) {
        //TODO: implement this api
        //self.request(url: "/game/friends/suggested", method: .get, params: nil, handler: handler)
        let response = TPUserListResponse(error: "", statusCode: 200)
        response.users = []
        handler(response)
    }
    func suggested(scope : UserListScope, handler : @escaping (TPUserListResponse) -> Void) {
        if scope == .italian {
            self.suggested_users(handler: handler)
        } else {
            self.suggested_friends(handler: handler)
        }
    }
    func search(scope : UserListScope, query : String, handler : @escaping (TPUserListResponse) -> Void) -> DataRequest {
        if scope == .italian {
            return self.search_user(query: query, handler: handler)
        } else {
            return self.search_friend(query: query, handler: handler)
        }
    }
    func search_user(query : String, handler : @escaping (TPUserListResponse) -> Void) -> DataRequest {
        return self.request(url: "/game/users/search?query=\(query)", method: .get, params: nil, handler: handler)
    }
    func search_friend(query : String, handler : @escaping (TPUserListResponse) -> Void) -> DataRequest {
        return self.search_user(query: query, handler: handler)
    }
}
