//
//  TPMessageResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 10/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPMessageResponse: TPResponse {
    var item : Message!
    
    override func load(json: JSON) {
        super.load(json: json)
        self.item = Message(json: json["message"])
    }
}
