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
        request(url: "/auth/login", method: .post, params: parameters, handler: handler)
    }
}
