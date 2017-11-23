//
//  TPRoundDetailsResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 04/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRoundDetailsResponse: TPRoundResponse {
    var categories : [Category] = []
    var users : [User] = []
    var partecipations : [Partecipation] = []
    var game : Game!
    var rounds : [Round] = []
    var scoreIncrement : Int!
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawUsers = json["users"].array {
            for item in rawUsers {
                users.append(User(json: item))
            }
        }
        if let rawCategories = json["categories"].array {
            for item in rawCategories {
                categories.append(Category(json: item))
            }
        }
        if let rawPartecipations = json["partecipations"].array {
            for item in rawPartecipations {
                partecipations.append(Partecipation(json: item))
            }
        }
        if let rawRounds = json["rounds"].array {
            for item in rawRounds {
                rounds.append(Round(json: item))
            }
        }
        self.scoreIncrement = json["score_increment"].int
        self.game = Game(json: json["game"])
    }
}
