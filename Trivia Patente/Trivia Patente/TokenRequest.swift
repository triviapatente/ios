//
//  TokenRequest.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 16/02/18.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class TokenRequest {
    private var token : String!
    private var deviceId : String!
    private var userId : Int32!
    
    private static let SEPARATOR = "|||"
    
    init(token : String, deviceId : String, userId : Int32) {
        self.token = token
        self.deviceId = deviceId
        self.userId = userId
    }
    func hasValues(deviceId : String, token : String, userId : Int32) -> Bool {
        return self.deviceId == deviceId && self.token == token && self.userId == userId
    }
    func serialize() -> String {
        return self.token + TokenRequest.SEPARATOR + self.deviceId + TokenRequest.SEPARATOR + "\(self.userId!)"
    }
    class func from(input : String?) -> TokenRequest? {
        guard let string = input else {
            return nil
        }
        let values = string.components(separatedBy: SEPARATOR)
        guard values.count == 3 else {
            return nil
        }
        let token = values[0]
        let deviceId = values[1]
        let user_id = Int32(values[2])
        guard let userId = user_id else {
            return nil
        }
        return TokenRequest(token: token, deviceId: deviceId, userId: userId)
    }
}
