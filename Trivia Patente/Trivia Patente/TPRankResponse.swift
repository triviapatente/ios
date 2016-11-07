//
//  TPRankResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 07/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRankResponse: TPResponse {
    var users : [User] = []
    var userPosition : Int?
    override func load(json: JSON) {
        super.load(json: json)
        if let rawUsers = json["rank"].array {
            for item in rawUsers {
                users.append(User(json: item))
            }
        }
        userPosition = json["my_position"].int
    }
}
