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
    static let RequestTimeout : TimeInterval = 10
    static let socket = SocketIOClient(socketURL: URL(string: HTTPManager.getBaseURL())!, config: [.log(false), .reconnectWait(6)])
    
    class func onDisconnect(callback: @escaping (() -> Void)) {
        socket.on("disconnect") { (data, ack) in
            callback()
        }
    }
    
    class func connect(handler : @escaping () -> Void, errorHandler: @escaping () -> Void) {
        if socket.status == .connected {
            MainViewController.handleReconnectionJoinRoom()
            handler()
        } else {
            socket.on("connect") { (data, ack) in
                self.socket.off("connect")
                self.socket.off("error")
                if let noConn = UIApplication.topViewController() as? NoConnectionViewController {
                    noConn.dismiss(animated: true, completion: nil)
                }
                MainViewController.handleReconnectionJoinRoom()
                handler()
            }
            socket.on("error") { (data, ack) in
                self.socket.off("error")
                errorHandler()
            }
            socket.connect()
        }
    }
    class func getStatus() -> SocketIOClientStatus
    {
        return socket.status
    }
    class func disconnect(handler : @escaping () -> Void) {
        self.joined_rooms.removeAll(keepingCapacity: false)
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
    class func unlisten(event : String) {
        SocketManager.socket.off(event)
    }
    class func unlisten(handlerId : UUID) {
        SocketManager.socket.off(id: handlerId)
    }
    class func unlisten(events : [String]) {
        for event in events {
            SocketManager.unlisten(event: event)
        }
    }
    class func unlisten(handlerIds : [UUID]) {
        for id in handlerIds {
            SocketManager.unlisten(handlerId: id)
        }
    }
    class func listen<T: TPResponse>(event : String, once: Bool = false, handler : @escaping (T) -> Void) -> UUID{
        SocketManager.unlisten(event: event)
        let normalCallback : (([Any], SocketAckEmitter) -> Void) = { (data, ack) in
            if let object = data.first as? [String : AnyObject] {
                let json = JSON.fromDict(dict: object)
                let response = T(json: json)
                handler(response)
            }
        }
        if once {
            return SocketManager.socket.once(event, callback: normalCallback)
        } else {
            return SocketManager.socket.on(event, callback: normalCallback)
        }
    }
    class func emit<T: TPResponse>(path : String, values : [String : AnyObject], handler : @escaping (T) -> Void) {
        let reqId = listen(event: path, once: true) { (response:  T) in
            if response.statusCode == 401 {
                SessionManager.drop()
                UIViewController.goToFirstAccess()
            } else {
                handler(response)
            }
        }
        
        if let token = SessionManager.getToken() {
            let body = [SessionManager.kTokenKey: token, "body": values, SessionManager.kDeviceIdKey: SessionManager.getDeviceId()] as [String : AnyObject]
            let cb = SocketManager.socket.emitWithAck(path, body)
            cb.timingOut(after: SocketManager.RequestTimeout, callback: { (data) in
                if let ack = data.first as? String {
                    if ack == SocketAckStatus.noAck.rawValue {
                        socket.off(id: reqId)
                        handler(T(error: "La richiesta non è andata a buon fine. Riprova."));
                    }
                }
            })
        }
    }
    @objc class func reuqestTimedOut(timer: Timer) {
        let req = timer.userInfo as! UUID
        SocketManager.socket.off(id: req)
        
    }
    static var joined_rooms : [String : Int32] = [:]
    class func joined(to value: Int32, type: String) -> Bool {
        return joined_rooms[type] == value
    }
    class func join(id : Int32, type : String, handler : @escaping (TPResponse) -> Void) {
        var cb : ((TPResponse) -> Void) = {(response) in
            FirebaseManager.removeNotifications(id: id)
            handler(response)
        }
        if id == joined_rooms[type] {
            let response = TPResponse(error: nil, statusCode: 200, success: true)
            cb(response)
        } else {
            emit(path: "join_room", values: ["id": id as AnyObject, "type": type as AnyObject]) { response in
                if response.success == true {
                    joined_rooms[type] = id
                }
                cb(response)
            }
        }
    }
    class func leave(type : String, handler : ((TPResponse) -> Void)? = nil) {
        if let _ = joined_rooms[type] {
            emit(path: "leave_room", values: ["type": type as AnyObject]) { response in
                joined_rooms.removeValue(forKey: type)
                if let cb = handler {
                    cb(response)
                }
            }
        } else {
            let response = TPResponse(error: nil, statusCode: 200, success: true)
            if let cb = handler {
                cb(response)
            }
        }
    }
}
