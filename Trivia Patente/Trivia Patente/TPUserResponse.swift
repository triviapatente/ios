//
//  TPUserResponse.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 08/11/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import Foundation
import SwiftyJSON

class TPUserResponse: TPResponse {
    var user : User?
    
    override func load(json: JSON) {
        super.load(json: json)
        user = User(json: self.json["user"])
    }
}
