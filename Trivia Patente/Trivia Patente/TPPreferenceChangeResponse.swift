//
//  TPPreferenceChangeResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 14/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPPreferenceChangeResponse: TPResponse {
    var preferences : Preferences!
    
    override func load(json: JSON) {
        super.load(json: json)
        self.preferences = Preferences(json: json["preferences"])
    }
}
