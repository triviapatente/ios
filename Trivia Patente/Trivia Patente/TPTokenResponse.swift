//
//  TPTokenResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 16/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPTokenResponse: TPResponse {
    var token : String?
    override func load(json: JSON) {
        super.load(json: json)
        token = self.json["token"].string
    }
}
