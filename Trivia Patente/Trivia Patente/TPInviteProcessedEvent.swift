//
//  TPInviteProcessedEvent.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 14/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPInviteProcessedEvent: TPResponse {
    var accepted : Bool!
    var invite : Invite!
    
    override func load(json: JSON) {
        super.load(json: json)
        self.accepted = json["accepted"].boolValue
    }
}
