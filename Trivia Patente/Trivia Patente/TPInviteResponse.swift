//
//  TPInviteResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPInviteResponse: TPResponse {
    var invite : Invite!
    
    override func load(json: JSON) {
        super.load(json: json)
        invite = Invite(json: json["invite"])
    }
}
