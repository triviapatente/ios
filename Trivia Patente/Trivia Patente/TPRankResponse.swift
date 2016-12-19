//
//  TPRankResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 07/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRankResponse: TPUserListResponse {
    var userPosition : Int32?
    override func load(json: JSON) {
        self.load(json: json, addMyUser: true)
    }
    func load(json: JSON, addMyUser : Bool) {
        super.load(json: json)
        if let rawUsers = json["rank"].array {
            for item in rawUsers {
                users.append(User(json: item))
            }
        }
        if addMyUser {
            self.checkAndAddUser()
        }
        userPosition = json["my_position"].int32
    }
    var map : [String : Int] {
        var output : [String : Int] = [:]
        var lastScore = -1
        var currentPosition : Int = 1
        for user in users {
            if user.score != lastScore {
                lastScore = user.score!
                output["\(lastScore)"] = currentPosition
                currentPosition += 1
            }
        }
        return output
    }
    func checkAndAddUser() {
        if let user = SessionManager.currentUser {
            if !self.users.contains(user) {
                self.users.append(user)
            }
        }
    }
}
