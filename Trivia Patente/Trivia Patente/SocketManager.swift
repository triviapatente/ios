//
//  SocketManager.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class SocketManager {
    static let socket = SocketIOClient(socketURL: URL(string: HTTPManager.getBaseURL())!, config: [.log(false)])
    
    class func connect(handler : @escaping () -> Void) {
        if socket.status == .connected {
            handler()
        } else {
            socket.on("connect") { (data, ack) in
                self.socket.off("connect")
                handler()
            }
            socket.connect()
        }
    }
    class func disconnect(handler : @escaping () -> Void) {
        if socket.status == .disconnected {
            handler()
        } else {
            socket.on("disconnect") { (data, ack) in
                self.socket.off("disconnect")
                handler()
            }
            socket.disconnect()
        }
    }
    class
        func listen<T: TPResponse>(event : String, handler : @escaping (T?) -> Void) {
        SocketManager.socket.on(event) { (data, ack) in
            if let object = data.first as? [String : AnyObject] {
                let json = JSON.fromDict(dict: object)
                let response = T(json: json)
                handler(response)
            } else {
                handler(nil)
            }
        }
    }
    class func emit<T: TPResponse>(path : String, values : [String : AnyObject], handler : @escaping (T?) -> Void) {
        listen(event: path) { (response:  T?) in
            SocketManager.socket.off(path)
            handler(response)
        }
        SocketManager.socket.emit(path, values)
    }
    static var joined_rooms : [String : [Int]] = [:]
    class func join(id : Int, type : String, handler : @escaping (TPResponse?) -> Void) {
        if let _ = joined_rooms[type]?.index(of: id) {
            let response = TPResponse(error: nil, statusCode: 200, success: true)
            handler(response)
        } else {
            emit(path: "join_room", values: ["id": id as AnyObject, "type": type as AnyObject]) { response in
                if response?.success == true {
                    if joined_rooms[type] == nil {
                        joined_rooms[type] = []
                    }
                    joined_rooms[type]!.append(id)
                }
                handler(response)
            }
        }
    }
    class func leave(id : Int, type : String, handler : @escaping (TPResponse?) -> Void) {
        emit(path: "leave_room", values: ["id": id as AnyObject, "type": type as AnyObject], handler: handler)
    }
}
