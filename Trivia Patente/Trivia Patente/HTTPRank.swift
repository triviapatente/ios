//
//  HTTPRank.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 07/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import Alamofire

enum RankDirection : String {
    case up = "up"
    case down = "down"
}

class HTTPRank: HTTPManager {
    func italian_rank(thresold: Int32?, direction: RankDirection?, handler : @escaping (TPRankResponse) -> Void) {
        _ = self.request(url: "/rank/global", method: .get, params: self.paramsFor(thresold: thresold, direction: direction), handler: handler)
    }
    func friends_rank(thresold: Int32?, direction: RankDirection?, handler : @escaping (TPRankResponse) -> Void) {
        italian_rank(thresold: thresold, direction: direction, handler: handler)
    }
    func rank(scope : UserListScope, thresold: Int32?, direction: RankDirection?, handler : @escaping (TPRankResponse) -> Void) {
        if scope == .friends {
            self.friends_rank(thresold: thresold, direction: direction, handler: handler)
        } else {
            self.italian_rank(thresold: thresold, direction: direction, handler: handler)
        }
    }
    func search(scope : UserListScope, query : String, handler : @escaping (TPRankSearchResponse) -> Void) -> DataRequest {
        if scope == .friends {
            return self.search_friends(query: query, handler: handler)
        } else {
            return self.search_users(query: query, handler: handler)
        }
    }
    func search_friends(query : String, handler : @escaping (TPRankSearchResponse) -> Void) -> DataRequest {
        return self.search_users(query: query, handler: handler)
    }
    func search_users(query : String, handler : @escaping (TPRankSearchResponse) -> Void) -> DataRequest {
        return self.request(url: "/rank/search", method: .get, params: ["query": query], handler: handler)
    }
    func paramsFor(thresold: Int32?, direction: RankDirection?) -> Parameters?
    {
        guard thresold != nil && direction != nil else {
            return nil
        }
        return ["thresold": thresold!, "direction": direction!.rawValue]
    }
}
