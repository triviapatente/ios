//
//  TPGameAnswerResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 28/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPGameAnswerResponse: TPResponse {
    var correct : Bool!
    override func load(json: JSON) {
        super.load(json: json)
        self.correct = json["correct_answer"].bool
    }
}
