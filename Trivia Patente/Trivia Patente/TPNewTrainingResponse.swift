//
//  TPNewTrainingResponse.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 15/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import Foundation
import SwiftyJSON

class TPNewTrainingResponse : TPResponse {
    var training : Training!
    var stats : TrainingStats?
    
    override func load(json: JSON) {
        super.load(json: json)
        training = Training(json: json["training"])
        stats = TrainingStats(json: json["stats"])
    }
}
