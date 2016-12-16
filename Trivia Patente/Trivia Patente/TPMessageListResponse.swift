//
//  TPMessageListResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 09/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPMessageListResponse: TPResponse {
    var messages : [Message] = []
    
    var map : [Date : [Message]] {
        var output : [Date : [Message]] = [:]
        for message in messages {
            let day = message.updatedAt!.withoutTime!
            if output[day] == nil {
                output[day] = []
            }
            output[day]!.append(message)
        }
        return output
    }
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawMessages = json["messages"].array {
            for item in rawMessages {
                messages.append(Message(json: item))
            }
        }
    }
}
