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
    let TIMEOUT = 6.0
    
    class func getBaseURL() -> String {
        return "http://192.168.1.15:8000"
    }
    
    
    func request<T: TPResponse>(url : String, method : HTTPMethod, params : Parameters?, auth : Bool = true, handler: @escaping (T) -> Void) {
        var headers = HTTPHeaders()
        if auth == true {
            if let token = SessionManager.getToken() {
                headers[SessionManager.kTokenKey] = token
            }
        }
        let destination = HTTPManager.getBaseURL() + url
        //TODO: add timeouts
        //let configuration = URLSessionConfiguration.default
        //configuration.timeoutIntervalForRequest = TIMEOUT
        //configuration.timeoutIntervalForResource = TIMEOUT
        //let manager = Alamofire.SessionManager(configuration: configuration)
        _ = Alamofire.request(destination, method: method, parameters: params, encoding: URLEncoding.default, headers: headers)
                     .validate(statusCode: 200..<300)
                     .validate(contentType: ["application/json"])
                     .responseModel(completionHandler: { (response : DataResponse<T>) in
                        if let result = response.result.value {
                            handler(result)
                        } else if response.response == nil {
                            let response = T(error: "Ci dispiace ma i server sono in manutenzione..\nRiprova tra un po\'! :/")
                            handler(response)
                        } else if let message = (response.result.error as? BackendError)?.message {
                            let response = T(error: message, statusCode: response.response?.statusCode)
                            if response.statusCode == 401 {
                                SessionManager.drop()
                                UIViewController.goToFirstAccess()
                            } else {
                                handler(response)
                            }
                        } else {
                            let response = T(error: "Errore sconosciuto. Riprova più tardi!")
                            handler(response)
                        }
                     })
    }
}
