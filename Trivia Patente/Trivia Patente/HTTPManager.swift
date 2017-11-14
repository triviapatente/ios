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
    let REQUEST_TIMEOUT = 6.0
    
    class func getBaseURL() -> String {
        return "http://192.168.1.136:8000"
    }
    
    class func getAuthHeaders(auth : Bool) -> HTTPHeaders {
        var headers = HTTPHeaders()
        if auth == true {
            if let token = SessionManager.getToken() {
                headers[SessionManager.kTokenKey] = token
            }
        }
        return headers
    }
    
    func upload<T: TPResponse>(url : String, method : HTTPMethod, data: Data, forHttpParam: String, fileName: String = "",  mimeType: String, parameters: Parameters?, auth : Bool = true, handler: @escaping (T) -> Void)
    {
        let headers = HTTPManager.getAuthHeaders(auth: auth)
        let destination = HTTPManager.getBaseURL() + url
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = REQUEST_TIMEOUT
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource = REQUEST_TIMEOUT
        Alamofire.upload(multipartFormData: { multipartData in
            multipartData.append(data, withName: forHttpParam, fileName: fileName, mimeType: mimeType)
            if parameters != nil   {
                for (key, value) in parameters! {
                    multipartData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
        }, to: destination, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseModel { (response : DataResponse<T>) in
                    if let result = response.result.value {
                        handler(result)
                    } else if response.response == nil {
                        let response = T(error: Strings.no_connection_toast)
                        handler(response)
                    } else if let message = (response.result.error as? BackendError)?.message {
                        let response = T(error: message, statusCode: response.response?.statusCode)
                        if response.statusCode == 401 && auth {
                            SessionManager.drop()
                            UIViewController.goToFirstAccess()
                        } else {
                            handler(response)
                        }
                    } else {
                        let response = T(error: "Errore sconosciuto. Riprova più tardi!")
                        handler(response)
                    }

                }
            case .failure(let encodingError):
                print("encodingError:\(encodingError)")
            }
        })
        
        
        
//        upload(data, to: destination, method: method, headers: headers)
//            .validate(statusCode: 200..<300)
//            .validate(contentType: ["application/json"])
//            .responseModel(completionHandler: { (response : DataResponse<T>) in
//            })
    }
    
    func request<T: TPResponse>(url : String, method : HTTPMethod, params : Parameters?, auth : Bool = true, handler: @escaping (T) -> Void) {
        let headers = HTTPManager.getAuthHeaders(auth: auth)
        let destination = HTTPManager.getBaseURL() + url
        
//        let AFManager = Alamofire.SessionManager(configuration: self.ALConfiguration())
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = REQUEST_TIMEOUT
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource = REQUEST_TIMEOUT
        Alamofire.request(destination, method: method, parameters: params, encoding: URLEncoding.default, headers: headers)
                     .validate(statusCode: 200..<300)
                     .validate(contentType: ["application/json"])
                     .responseModel(completionHandler: { (response : DataResponse<T>) in
                        if let result = response.result.value {
                            handler(result)
                        } else if response.response == nil {
                            let response = T(error: Strings.no_connection_toast)
                            handler(response)
                        } else if let message = (response.result.error as? BackendError)?.message {
                            let response = T(error: message, statusCode: response.response?.statusCode)
                            if response.statusCode == 401 && auth {
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
