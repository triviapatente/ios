//
//  HTTPRank.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 07/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

enum RankDirection : String {
    case up = "up"
    case down = "down"
}

class HTTPRank: HTTPManager {
    func italian_rank(thresold: Int32, direction: RankDirection, handler : @escaping (TPRankResponse) -> Void) {
        self.request(url: "/rank/global", method: .get, params: ["thresold": thresold, "direction": direction.rawValue], handler: handler)
    }
    func friends_rank(thresold: Int32, direction: RankDirection, handler : @escaping (TPRankResponse) -> Void) {
        italian_rank(thresold: thresold, direction: direction, handler: handler)
    }
    func rank(scope : UserListScope, thresold: Int32, direction: RankDirection, handler : @escaping (TPRankResponse) -> Void) {
        if scope == .friends {
            self.friends_rank(thresold: thresold, direction: direction, handler: handler)
        } else {
            self.italian_rank(thresold: thresold, direction: direction, handler: handler)
        }
    }
    func search(scope : UserListScope, query : String, handler : @escaping (TPRankSearchResponse) -> Void) {
        if scope == .friends {
            self.search_friends(query: query, handler: handler)
        } else {
            self.search_users(query: query, handler: handler)
        }
    }
    func search_friends(query : String, handler : @escaping (TPRankSearchResponse) -> Void) {
        self.search_users(query: query, handler: handler)
    }
    func search_users(query : String, handler : @escaping (TPRankSearchResponse) -> Void) {
        self.request(url: "/rank/search", method: .get, params: ["query": query], handler: handler)
    }
}
