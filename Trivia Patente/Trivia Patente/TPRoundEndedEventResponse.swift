//
//  TPRoundEndedEventResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 04/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRoundEndedEventResponse: TPRoundResponse {
    var category : Category!
    override func load(json: JSON) {
        super.load(json: json)
        self.category = Category(json: json["category"])
    }
}

