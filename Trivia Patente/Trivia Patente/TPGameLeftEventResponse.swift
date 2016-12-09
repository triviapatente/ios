//
//  TPGameLeftEventResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 08/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPGameLeftEventResponse: TPGameEndedEventResponse {
    var user : User!
    
    override func load(json: JSON) {
        super.load(json: json)
        self.user = User(json: json["user"])
    }
}

