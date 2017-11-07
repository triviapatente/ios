//
//  SocketAuth.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation

class SocketAuth : SocketManager {
    
    func global_infos(handler : @escaping (TPConnectResponse) -> Void) {
        SocketAuth.emit(path: "global_infos", values: [:], handler: handler)
    }
    func logout(handler : @escaping (TPResponse) -> Void) {
        SocketAuth.emit(path: "logout", values: [:], handler: handler)
    }
}
