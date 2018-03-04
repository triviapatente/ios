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
        request(url: "/auth/login", method: .post, params: parameters, auth: false) {   (response : TPAuthResponse) in
            guard self != nil else { return }
            if let token = response.token {
                SessionManager.set(token: token)
            }
            if let user = response.user {
                SessionManager.set(user: user)
            }
            FirebaseManager.refreshToken()
            handler(response)
        }
    }
    func forgotPassword(usernameOrEmail : String, handler : @escaping (TPForgotResponse) -> Void) {
        let parameters = ["usernameOrEmail": usernameOrEmail]
        request(url: "/auth/password/request", method: .post, params: parameters, auth: false) {   (response : TPForgotResponse) in
            guard self != nil else { return }
            handler(response)
        }
    }
    func fb_auth(token : String, handler : @escaping (TPAuthResponse) -> Void) {
        let parameters = ["token": token]
        request(url: "/fb/auth", method: .post, params: parameters, auth: false) {  (response : TPAuthResponse) in
            guard self != nil else { return }
            if let token = response.token {
                SessionManager.set(token: token)
            }
            if let user = response.user {
                SessionManager.set(user: user)
            }
            handler(response)
        }

    }
    func link_to_fb(token : String, handler : @escaping (TPFBResponse) -> Void) {
        let parameters = ["token": token]
        request(url: "/fb/link", method: .post, params: parameters) {  (response : TPFBResponse) in
            guard self != nil else { return }
            if let user = response.user {
                SessionManager.set(user: user)
            }
            if let infos = response.infos {
                FBManager.set(infos: infos)
            }
            handler(response)
        }
    }
    func user(handler : @escaping (TPUserResponse) -> Void) {
        request(url: "/account/user", method: .get, params: nil, handler: handler)
    }
    func logout(handler : @escaping (TPAuthResponse) -> Void) {
//        request(url: "/auth/logout", method: .post, params: nil) { (response : TPAuthResponse) in
//            if response.success == true {
        
            HTTPManager().unregisterForPush { response in
                print("Unregistered?", response.success)
                if response.success {
                    FirebaseManager.dropTokenRequest()
                }
            }
                SessionManager.drop()
                SocketManager.disconnect {}
                handler(TPAuthResponse(error: nil, statusCode: 200, success: true))
//            }
//            handler(response)
//        }
    }
    
    func register(username : String, email : String, password : String, handler : @escaping (TPAuthResponse) -> Void) {
        let parameters = ["username": username, "password": password, "email": email]
        request(url: "/auth/register", method: .post, params: parameters, auth: false) {   (response : TPAuthResponse) in
            guard self != nil else { return }
            if let token = response.token {
                SessionManager.set(token: token)
            }
            if let user = response.user {
                SessionManager.set(user: user)
            }
            FirebaseManager.refreshToken()
            handler(response)
        }
    }
    func changePassword(old : String, new : String, handler : @escaping (TPTokenResponse) -> Void) {
        let parameters = ["old_value": old, "new_value": new]
        request(url: "/auth/password/edit", method: .post, params: parameters){  (response : TPTokenResponse) in
            guard self != nil else { return }
            if let token = response.token {
                SessionManager.set(token: token)
            }
            handler(response)
        }

    }
}
