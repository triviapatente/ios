//
//  TPUserAnsweredEvent.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/01/17.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPQuestionAnsweredEvent: TPResponse {
    var quiz_id : Int32!
    var answer : Question!
    
    override func load(json: JSON) {
        super.load(json: json)
        self.quiz_id = json["quiz_id"].int32
        self.answer = Question(json: json["answer"])
    }
}
