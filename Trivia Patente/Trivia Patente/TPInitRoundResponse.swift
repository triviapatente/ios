//
//  InitRoundResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPInitRoundResponse: TPResponse {
    var round : Round!
    
    override func load(json: JSON) {
        super.load(json: json)
        self.round = Round(json: json["round"])
    }
}
