//
//  FBManager.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 18/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class FBManager {
    static let permissions = ["public_profile", "email", "user_birthday"]
    class func login(sender : UIViewController) {
        let manager = FBSDKLoginManager()
        manager.logIn(withReadPermissions: permissions, from: sender) { (handler, error) in
             if let fbHandler = handler {
                guard error == nil else {
                    //TODO: handle error
                    return
                }
                guard fbHandler.declinedPermissions.isEmpty else {
                    //TODO: handle error
                    return
                }
                if let token = fbHandler.token {
                    print("token date", token.expirationDate)
                    print("token id", token.userID)
                    print("token", token.tokenString)
                }
            }
        }
    }
}
