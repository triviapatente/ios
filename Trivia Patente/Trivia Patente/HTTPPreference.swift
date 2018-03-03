//
//  HTTPPreference.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 14/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class HTTPPreference: HTTPManager {
    func change_notifications(key : String, value : Bool, handler : @escaping (TPPreferenceChangeResponse) -> Void) {
        self.request(url: "/preferences/notification/\(key)/edit", method: .post, params: ["new_value": value]) {[unowned self] (response : TPPreferenceChangeResponse) in
            guard self != nil else { return }
            if response.success == true {
                Shared.preferences = response.preferences
            }
            handler(response)
        }
    }
    func change_others(key : String, value : PreferenceVisibility, handler : @escaping (TPPreferenceChangeResponse) -> Void) {
        self.request(url: "/preferences/\(key)/edit", method: .post, params: ["new_value": value.rawValue]) {[unowned self] (response : TPPreferenceChangeResponse) in
            guard self != nil else { return }
            if response.success == true {
                Shared.preferences = response.preferences
            }
            handler(response)
        }
    }
}
