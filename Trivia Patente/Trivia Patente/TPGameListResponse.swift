//
//  TPGameListResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPGameListResponse: TPResponse {
    var games : [Game] = []
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawGames = json["recent_games"].array {
            for item in rawGames {
                games.append(Game(json: item))
            }
        }
    }
    convenience init() {
        self.init(error: "", statusCode: 200)
    }
}
