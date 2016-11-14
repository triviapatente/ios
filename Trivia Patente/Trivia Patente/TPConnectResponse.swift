//
//  TPConnectResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 28/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPConnectResponse: TPResponse {
    var invitesCount : Int?
    var globalRankPosition : Int?
    var friendsRankPosition : Int?
    var preferences : Preferences!
    var stats : [Category] = []
    
    override func load(json: JSON) {
        super.load(json: json)
        invitesCount = json["invites"].int
        globalRankPosition = json["global_rank_position"].int
        friendsRankPosition = json["friends_rank_position"].int
        preferences = Preferences(json: json["preferences"])
        if let rawStats = json["stats"].array {
            for item in rawStats {
                stats.append(Category(json: item))
            }
        }
        Shared.preferences = preferences
        Shared.categories = stats
    }
}
