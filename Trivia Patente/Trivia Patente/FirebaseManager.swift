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
        refreshToken()
    }
    class func refreshToken() {
        if let token = Messaging.messaging().fcmToken {
            sendToken(token: token)
        } else {
            self.register()
        }

    }
    class func getGameFrom(notification : UNNotification) -> Game? {
        return getGameFrom(request: notification.request)
    }
    class func getGameFrom(request : UNNotificationRequest) -> Game? {
        let game = request.content.userInfo[AnyHashable("game")] as! String
        if let json = JSON.fromData(data: game.data(using: .utf8)) {
            return Game(json: json)
        }
        return nil
    }
    class func getOpponentFrom(notification : UNNotification) -> User? {
        return getOpponentFrom(request: notification.request)
    }
    class func getOpponentFrom(request : UNNotificationRequest) -> User? {
        let game = request.content.userInfo[AnyHashable("opponent")] as! String
        if let json = JSON.fromData(data: game.data(using: .utf8)) {
            return User(json: json)
        }
        return nil
    }
    class func getRequestsForGameId(notifications: [UNNotification], gameId : Int32) -> [UNNotification] {
        var output : [UNNotification] = []
        for notification in notifications {
            if let game = getGameFrom(notification: notification), game.id == gameId {
                output.append(notification)
            }
        }
        return output
    }
    class func removeNotifications(id : Int32) {
        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications { (notifications) in
            let identifiers = getRequestsForGameId(notifications: notifications, gameId: id).map({$0.request.identifier})
            center.removeDeliveredNotifications(withIdentifiers: identifiers)
        }
    }
    class func canDisplayNotification(notification : UNNotification) -> Bool {
        guard let game = getGameFrom(notification: notification) else { return false }
        guard let joinedRoom = SocketManager.joined_rooms["game"] else { return true }
        return joinedRoom != game.id!
    }
    private static let LAST_TOKEN_REQUEST_KEY = "last_token_request"
    class func getLastTokenRequest() -> TokenRequest? {
        let value = UserDefaults.standard.string(forKey: LAST_TOKEN_REQUEST_KEY)
        return TokenRequest.from(input: value) ?? nil;
    }
    class func saveTokenRequest(token : String, user : User) {
        let request = TokenRequest(token: token, deviceId: SessionManager.getDeviceId(), userId: user.id!)
        saveTokenRequest(request: request)
    }
    class func saveTokenRequest(request : TokenRequest) {
        let output = request.serialize()
        let defaults = UserDefaults.standard
        defaults.set(output, forKey: LAST_TOKEN_REQUEST_KEY)
        defaults.synchronize()
    }
    class func dropTokenRequest() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: LAST_TOKEN_REQUEST_KEY)
        defaults.synchronize()
    }
    class func alreadySent(token : String) -> Bool? {
        guard let user = SessionManager.currentUser else {
            return nil
        }
        let deviceId = SessionManager.getDeviceId()
        let request = FirebaseManager.getLastTokenRequest()
        return request?.hasValues(deviceId: deviceId, token: token, userId: user.id!) ?? false
    }
    class func sendToken(token : String) {
        guard let sent = alreadySent(token: token), !sent else {
            return
        }
        let provider = HTTPManager()
        provider.registerForPush(token: token) { response in
            if response.success == true {
                FirebaseManager.saveTokenRequest(token: token, user: SessionManager.currentUser!)
            }
            print("Token registration response: \(response.json)")
        }
    }
}
