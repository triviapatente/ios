//
//  TPFBResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 20/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPFBResponse: TPAuthResponse {
    var infos : FBInfos!
    
    override func load(json: JSON) {
        super.load(json: json)
        infos = FBInfos(json: json["infos"])
    }
}
