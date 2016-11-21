//
//  TPInviteListResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPInviteListResponse: TPResponse {
    var invites : [Invite] = []
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawInvites = json["invites"].array {
            for item in rawInvites {
                invites.append(Invite(json: item))
            }
        }
    }
}
