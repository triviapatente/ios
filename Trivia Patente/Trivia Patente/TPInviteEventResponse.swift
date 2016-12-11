//
//  TPInviteEventResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPInviteEventResponse: TPResponse {
    var user : User!
    var invite : Invite!
    
    override func load(json: JSON) {
        super.load(json: json)
        self.user = User(json: json["user"])
        self.invite = Invite(json: json["invite"])
    }
}
