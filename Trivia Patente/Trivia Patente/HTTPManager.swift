//
//  HTTPManager.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import Alamofire

class HTTPManager {
    let kTokenKey = "tp-session-auth"
    let baseURL = "http://192.168.33.10:8000"
    func setToken(token : String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: kTokenKey)
        defaults.synchronize()
    }
    func getToken() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: kTokenKey)
    }
    
    func request<T: TPResponse>(url : String, method : HTTPMethod, params : Parameters?, auth : Bool = true, handler: @escaping (T) -> Void) {
        var headers = HTTPHeaders()
        if auth == true {
            if let token = self.getToken() {
                headers[kTokenKey] = token
            }
        }
        let destination = baseURL + url
        _ = Alamofire.request(destination, method: method, parameters: params, encoding: URLEncoding.default, headers: headers)
                     .validate(statusCode: 200..<300)
                     .validate(contentType: ["application/json"])
                     .responseModel(completionHandler: { (response : DataResponse<T>) in
                        if let result = response.result.value {
                            handler(result)
                        } else if response.response == nil {
                            let response = T(error: "No response from server")
                            handler(response)
                        } else if let message = (response.result.error as? BackendError)?.message {
                            let response = T(error: message, statusCode: response.response?.statusCode)
                            handler(response)
                        } else {
                            let response = T(error: "Unknown error")
                            handler(response)
                        }
                     })
    }
}
