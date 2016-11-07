//
//  HTTPRank.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 07/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class HTTPRank: HTTPManager {
    func italian_rank(handler : @escaping (TPRankResponse) -> Void) {
        self.request(url: "/rank/global", method: .get, params: nil) { (response : TPRankResponse) in
            sleep(3)
            response.users = response.users + response.users
            handler(response)
        }
    }
    func friends_rank(handler : @escaping (TPRankResponse) -> Void) {
        italian_rank(handler: handler)
    }
}
