//
//  FirebaseManager.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 14/12/17.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase
import SwiftyJSON

class FirebaseManager {
    class func register() {
        let application = UIApplication.shared
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (success, error) in
        }
        application.registerForRemoteNotifications()
    }
    class func initialize(delegate: UNUserNotificationCenterDelegate) {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = delegate
    }
    class func getGameFrom(notification : UNNotification) -> Game? {
        let game = notification.request.content.userInfo[AnyHashable("game")] as! String
        if let json = JSON.fromData(data: game.data(using: .utf8)) {
            return Game(json: json)
        }
        return nil
    }
    class func getOpponentFrom(notification : UNNotification) -> User? {
        let game = notification.request.content.userInfo[AnyHashable("opponent")] as! String
        if let json = JSON.fromData(data: game.data(using: .utf8)) {
            return User(json: json)
        }
        return nil
    }
    class func canDisplayNotification(notification : UNNotification) -> Bool {
        guard let game = getGameFrom(notification: notification) else { return false }
        guard let joinedRoom = SocketManager.joined_rooms["game"] else { return true }
        return joinedRoom != game.id!
    }
    class func obtainToken(token : String) {
        let provider = HTTPManager()
        provider.registerForPush(token: token) { success in
            print("Token registration response: \(success.json)")
        }
    }
}
