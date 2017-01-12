//
//  TPRecentGameEvent.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 12/01/17.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRecentGameEvent: TPResponse {
    var action : TPEventAction!
    var game : Game!
    
    override func load(json: JSON) {
        super.load(json: json)
        self.game = Game(json: json["game"])
        self.action = TPEventAction.from(event: json["action"].stringValue)
    }
}
