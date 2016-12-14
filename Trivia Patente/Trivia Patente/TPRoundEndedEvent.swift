//
//  TPRoundEndedEventResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 04/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRoundEndedEvent: TPRoundResponse {
    var category : Category!
    var globally : Bool!
    override func load(json: JSON) {
        super.load(json: json)
        self.category = Category(json: json["category"])
        self.globally = json["globally"].boolValue
    }
}

