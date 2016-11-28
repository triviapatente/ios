//
//  TPQuizListResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 28/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPQuizListResponse: TPResponse {
    var questions : [Quiz] = []
    override func load(json: JSON) {
        super.load(json: json)
        if let rawQuizzes = json["questions"].array {
            for item in rawQuizzes {
                questions.append(Quiz(json: item))
            }
        }
    }
}
