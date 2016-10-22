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
                self.setToken(token: token)
            }
            handler(response)
        }
    }
    func user(handler : @escaping (TPAuthResponse) -> Void) {
        request(url: "/auth/user", method: .get, params: nil, handler: handler)
    }
    
    func register(username : String, email : String, password : String, handler : @escaping (TPAuthResponse) -> Void) {
        let parameters = ["username": username, "password": password, "email": email]
        request(url: "/auth/register", method: .post, params: parameters, auth: false) { (response : TPAuthResponse) in
            if let token = response.token {
                self.setToken(token: token)
            }
            handler(response)
        }
    }
}
