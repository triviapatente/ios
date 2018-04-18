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
    var privacyPolicyLastUpdate: Date?
    var termsLastUpdate: Date?
    var preferences : Preferences!
    var stats : [Category] = []
    var fbInfos : FBInfos!
    var training_stats : TrainingStats!
    
    
    override func load(json: JSON) {
        super.load(json: json)
        invitesCount = json["invites"].int
        globalRankPosition = json["global_rank_position"].int
        friendsRankPosition = json["friends_rank_position"].int
        privacyPolicyLastUpdate = json["privacy_policy_last_update"].stringValue.dateFromGMT
        
        termsLastUpdate = json["terms_and_conditions_last_update"].stringValue.dateFromGMT
        preferences = Preferences(json: json["preferences"])
        if let rawStats = json["stats"].array {
            for item in rawStats {
                stats.append(Category(json: item))
            }
        }
        training_stats = TrainingStats(json: json["training_stats"])
//        fbInfos = FBInfos(json: json["fb"])
//        FBManager.set(infos: fbInfos)
        Shared.preferences = preferences
        Shared.categories = stats
    }
}
