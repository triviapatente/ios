//
//  TPGameAnswerEvent.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 14/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPGameAnswerEvent: TPResponse {
    var correct : Bool!
    var user : User!
    override func load(json: JSON) {
        super.load(json: json)
        self.correct = json["correct_answer"].bool
        self.user = User(json: json["user"])
    }
}
