//
//  SocketManager.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation
import SocketIO
class SocketManager {
    static let socket = SocketIOClient(socketURL: URL(string: HTTPManager.getBaseURL())!, config: [.log(true)])
    
    class func connect(handler : @escaping () -> Void) {
        socket.on("connect") { (data, ack) in
            handler()
        }
        socket.connect()
    }
    class func disconnect(handler : @escaping () -> Void) {
        socket.on("disconnect") { (data, ack) in
            handler()
        }
        socket.disconnect()
    }
    func listen<T: TPResponse>(event : String, handler : @escaping (T?) -> Void) {
        SocketManager.socket.on(event) { (data, ack) in
            if let json = data.first as? Data {
                let response = T(object: json)
                handler(response)
            } else {
                handler(nil)
            }
        }
    }
    func emit<T: TPResponse>(path : String, values : [String : AnyObject], handler : @escaping (T?) -> Void) {
        SocketManager.socket.on(path) { (data, ack) in
            if let json = data.first as? Data {
                let response = T(object: json)
                handler(response)
            } else {
                handler(nil)
            }
        }
        SocketManager.socket.emit(path, values)
    }
}
