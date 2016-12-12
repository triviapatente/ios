//
//  InitRoundResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

enum RoundWaiting : String {
    case category = "category"
    case game = "game"
    case invite = "invite"
    static func from(json : JSON) -> RoundWaiting? {
        if let value = json.string {
            if value == self.category.rawValue {
                return self.category
            } else if value == self.game.rawValue {
                return self.game
            } else if value == self.invite.rawValue {
                return self.invite
            }
        }
        return nil
    }
}
class TPInitRoundResponse: TPResponse {
    var round : Round!
    var waiting : RoundWaiting? //se è settato, sto aspettando per le azioni di qualcuno (io o opponent). può essere non settato in caso di game finito
    var waiting_for : User? //se è settato, bisogna andare nella wait page se l'utente non sono io, nelle pagine dedicate se sono io
    var ended : Bool!
    var category : Category?
    var opponent_online : Bool!
    override func load(json: JSON) {
        super.load(json: json)
        
        self.waiting = RoundWaiting.from(json: json["waiting"])
        self.ended = json["ended"].boolValue
        self.opponent_online = json["opponent_online"].boolValue
        self.category = Category(json: json["category"])
        if json["round"].exists() {
            self.round = Round(json: json["round"])
        }
        if json["waiting_for"].exists() {
            self.waiting_for = User(json: json["waiting_for"])
        }
        if json["category"].exists() {
            self.category = Category(json: json["category"])
        }
    }
}
