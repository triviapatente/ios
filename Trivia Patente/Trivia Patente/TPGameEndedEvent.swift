//
//  TPGameEndedEventResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 08/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPGameEndedEvent: TPResponse {
    var partecipations : [Partecipation] = []
    var winner_id : Int32!
    var game : Game!
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawPartecipations = json["partecipations"].array {
            for item in rawPartecipations {
                partecipations.append(Partecipation(json: item))
            }
        }
        self.game = Game(json: json["game"])
        self.winner_id = json["winner_id"].int32
    }
}
