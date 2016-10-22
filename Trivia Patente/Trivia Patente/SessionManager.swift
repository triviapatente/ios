//
//  SessionManager.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class SessionManager {
    static let kTokenKey = "tp-session-auth"
    static let kUserkey = "tp-current-user"

    class func set(token : String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: kTokenKey)
        defaults.synchronize()
    }
    class func set(user : User) {
        let defaults = UserDefaults.standard
        let object = NSKeyedArchiver.archivedData(withRootObject: user)
        defaults.set(object, forKey: kUserkey)
        defaults.synchronize()
    }
    static var currentUser : User? {
        let defaults = UserDefaults.standard
        let object = defaults.object(forKey: kUserkey) as! Data
        if let user = NSKeyedUnarchiver.unarchiveObject(with: object) as? User {
            return user
        }
        return nil
    }
    class func getToken() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: kTokenKey)
    }
}
