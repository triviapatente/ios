//
//  TBForgotResponse.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 25/10/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPForgotResponse: TPResponse {
    // TODO: conformare a quanto fatto su backend
    var requestSuccess : Bool?
    override func load(json: JSON) {
        super.load(json: json)
        success = self.json["requestSuccess"].boolValue
    }
}
