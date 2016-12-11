//
//  TPLeaveDecrementResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPLeaveDecrementResponse: TPResponse {
    var decrement : Int!
    
    override func load(json: JSON) {
        super.load(json: json)
        decrement = json["decrement"].int
    }
}
