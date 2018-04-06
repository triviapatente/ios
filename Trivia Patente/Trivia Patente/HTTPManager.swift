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
    static let REQUEST_TIMEOUT : TimeInterval = 15.0
    var manager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = HTTPManager.REQUEST_TIMEOUT
        configuration.timeoutIntervalForResource = HTTPManager.REQUEST_TIMEOUT
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    class func getBaseURL() -> String {
        return "https://triviapatente.it:8000"
    }
    func registerForPush(token : String, handler: @escaping (TPResponse) -> Void) {
        _ = self.request(url: "/ws/registerForPush", method: .post, params: ["token": token, "os": "iOS", "deviceId": SessionManager.getDeviceId()], handler: handler)
    }
    func unregisterForPush(handler: @escaping (TPResponse) -> Void) {
        _ = self.request(url: "/ws/unregisterForPush", method: .post, params: ["os": "iOS", "deviceId": SessionManager.getDeviceId()], handler: handler)
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
        
        manager.upload(multipartFormData: { multipartData in
            multipartData.append(data, withName: forHttpParam, fileName: fileName, mimeType: mimeType)
            if parameters != nil   {
                for (key, value) in parameters! {
                    multipartData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
        }, to: destination, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                _ = upload.responseModel {(response : DataResponse<T>) in
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
                        handler(T(error: Strings.unknown_error))
                    }

                }
            case .failure(let error):
                if error._code == 1 {
                    //HANDLE TIMEOUT HERE
                    handler(T(error: Strings.request_timout_error))
                } else {
                    handler(T(error: Strings.unknown_error))
                }
                print("encodingError:\(error)")
            }
        })
        
        
        
//        upload(data, to: destination, method: method, headers: headers)
//            .validate(statusCode: 200..<300)
//            .validate(contentType: ["application/json"])
//            .responseModel(completionHandler: { (response : DataResponse<T>) in
//            })
    }
    
    func request<T: TPResponse>(url : String, method : HTTPMethod, params : Parameters?, auth : Bool = true, jsonBody : Bool = false, handler: @escaping (T) -> Void) -> DataRequest {
        let headers = HTTPManager.getAuthHeaders(auth: auth)
        let destination = HTTPManager.getBaseURL() + url
        let request = manager.request(destination, method: method, parameters: params, encoding: jsonBody ? JSONEncoding.default : URLEncoding.default, headers: headers)
                     .validate(statusCode: 200..<300)
                     .validate(contentType: ["application/json"])
                     .responseModel(completionHandler: { (response : DataResponse<T>) in
                        switch (response.result) {
                        case .success:
                            //do json stuff
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
                                handler(T(error: Strings.unknown_error))
                            }
                            break
                        case .failure(let error):
                            if let mError = error as? BackendError, mError.cancelled == true {
                                
                            } else if error._code == NSURLErrorTimedOut {
                                //HANDLE TIMEOUT HERE
                                handler(T(error: Strings.request_timout_error))
                            } else {
                                handler(T(error: Strings.unknown_error))
                            }
                            print("\n\nAuth request failed with error:\n \(error._code) \(error)")
                            break
                        }
                        
                     })
        return request
    }
}
