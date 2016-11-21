//
//  NewGameResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPNewGameResponse: TPResponse {
    var game : Game!
    var opponent : User!
    
    override func load(json: JSON) {
        super.load(json: json)
        opponent = User(json: json["user"])
        game = Game(json: json["game"])
    }
}
