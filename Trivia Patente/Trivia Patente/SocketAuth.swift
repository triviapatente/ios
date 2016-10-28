//
//  SocketAuth.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation

class SocketAuth : SocketManager {
    
    func authenticate(token : String, handler : @escaping (TPConnectResponse?) -> Void) {
        let params : [String : AnyObject] = ["token": token as AnyObject]
        self.emit(path: "auth", values: params, handler: handler)
    }
    func logout(handler : @escaping (TPResponse?) -> Void) {
        self.emit(path: "logout", values: [:], handler: handler)
    }
}
