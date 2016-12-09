//
//  TPGameEndedEventResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 08/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPGameEndedEventResponse: TPResponse {
    var partecipations : [Partecipation] = []
    var winner : User!
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawPartecipations = json["partecipations"].array {
            for item in rawPartecipations {
                partecipations.append(Partecipation(json: item))
            }
        }
        self.winner = User(json: json["winner"])
    }
}
