//
//  TPAuthResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPAuthResponse: TPTokenResponse {
    var user : User?
    override func load(json: JSON) {
        super.load(json: json)
        user = User(json: self.json["user"])
    }
}
