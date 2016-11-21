//
//  TPSearchOpponentResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPSearchOpponentResponse: TPResponse {
    var users : [User] = []
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawUsers = json["matches"].array {
            for item in rawUsers {
                users.append(User(json: item))
            }
        }
    }
}
