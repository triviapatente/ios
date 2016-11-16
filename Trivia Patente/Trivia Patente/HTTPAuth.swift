//
//  HTTPAuth.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import Alamofire

class HTTPAuth : HTTPManager {
    func login(user : String, password : String, handler : @escaping (TPAuthResponse) -> Void) {
        let parameters = ["user": user, "password": password]
        request(url: "/auth/login", method: .post, params: parameters, auth: false) { (response : TPAuthResponse) in
            if let token = response.token {
                SessionManager.set(token: token)
            }
            if let user = response.user {
                print(user.dictionaryRepresentation())
                SessionManager.set(user: user)
            }
            handler(response)
        }
    }
    func user(handler : @escaping (TPAuthResponse) -> Void) {
        request(url: "/auth/user", method: .get, params: nil, handler: handler)
    }
    func logout(handler : @escaping (TPAuthResponse) -> Void) {
        request(url: "/auth/logout", method: .post, params: nil) { (response : TPAuthResponse) in
            if response.success == true {
                SessionManager.drop()
                SocketManager.disconnect {}
            }
            handler(response)
        }
    }
    
    func register(username : String, email : String, password : String, handler : @escaping (TPAuthResponse) -> Void) {
        let parameters = ["username": username, "password": password, "email": email]
        request(url: "/auth/register", method: .post, params: parameters, auth: false) { (response : TPAuthResponse) in
            if let token = response.token {
                SessionManager.set(token: token)
            }
            if let user = response.user {
                SessionManager.set(user: user)
            }
            handler(response)
        }
    }
    func changePassword(old : String, new : String, handler : @escaping (TPTokenResponse) -> Void) {
        let parameters = ["old_value": old, "new_value": new]
        request(url: "/auth/password/edit", method: .post, params: parameters){ (response : TPTokenResponse) in
            if let token = response.token {
                SessionManager.set(token: token)
            }
            handler(response)
        }

    }
}
