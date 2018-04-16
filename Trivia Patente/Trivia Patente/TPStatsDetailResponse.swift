//
//  TPStatsDetailResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPStatsDetailResponse: TPResponse {
    var wrong_answers : [Quiz] = []
    var percentages : [String : (Int, Int)] = [:]
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawAnswers = json["wrong_answers"].array {
            for item in rawAnswers {
                wrong_answers.append(Quiz(json: item))
            }
        }
        if let dict = json["progress"].dictionary {
            for (key, value) in dict {
                percentages[key] = (value["total_answers"].intValue, value["correct_answers"].intValue)
            }
        }
    }
}
