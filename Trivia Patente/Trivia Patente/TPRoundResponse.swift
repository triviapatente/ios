//
//  TPRoundResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 08/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRoundResponse: TPResponse {
    var quizzes : [Quiz] = []
    var answers : [Question] = []
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawQuizzes = json["quizzes"].array {
            for item in rawQuizzes {
                quizzes.append(Quiz(json: item))
            }
        }
        if let rawAnswers = json["answers"].array {
            for item in rawAnswers {
                answers.append(Question(json: item))
            }
        }
    }
}
