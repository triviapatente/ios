//
//  SessionManager.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class SessionManager {
    static let kTokenKey = "tp-session-token"
    static let kUserKey = "tp-current-user"

    class func set(token : String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: kTokenKey)
        defaults.synchronize()
    }
    class func set(user : User) {
        let defaults = UserDefaults.standard
        let object = NSKeyedArchiver.archivedData(withRootObject: user)
        defaults.set(object, forKey: kUserKey)
        defaults.synchronize()
    }
    static var currentUser : User? {
        let defaults = UserDefaults.standard
        let object = defaults.object(forKey: kUserKey) as! Data
        if let user = NSKeyedUnarchiver.unarchiveObject(with: object) as? User {
            return user
        }
        return nil
    }
    class func getToken() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: kTokenKey)
    }
    class func drop() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: kTokenKey)
        defaults.removeObject(forKey: kUserKey)
        defaults.synchronize()
    }
    class func authenticateSocket(handler : @escaping (TPConnectResponse?) -> Void) {
        let socketAuth = SocketAuth()
        if let token = SessionManager.getToken() {
            SocketManager.connect {
                socketAuth.authenticate(token: token, handler: handler)
            }
        }
    }
}
