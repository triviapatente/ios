//
//  TPTrainingsListResponse.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 15/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import Foundation
import SwiftyJSON

class TPTrainingsListResponse : TPResponse {
    var trainings : [Training] = []
    var stats : TrainingStats?
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawTrainings = json["trainings"].array {
            for item in rawTrainings {
                trainings.append(Training(json: item))
            }
        }
        stats = TrainingStats(json: json["stats"])
    }
}
