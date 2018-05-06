//
//  DataRequest.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
extension DataRequest {
    func responseModel<T : TPResponse>(queue: DispatchQueue? = nil, completionHandler : @escaping (DataResponse<T>) -> Void) -> Self {
        let serializer = DataResponseSerializer<T> { request, response, data, error in
            if let _ = response {
                let json = JSON.fromData(data: data)
                let tpResponse = T(json: json, statusCode: response!.statusCode)
                if tpResponse.statusCode == 200 && tpResponse.success == true {
                    return .success(tpResponse)
                } else {
                    return .failure(BackendError(message: tpResponse.message))
                }
            } else {
                if let mError = error, mError._code == NSURLErrorCancelled {
                    return .failure(BackendError(cancelled: true))
                } else {
                    return .failure(BackendError(message: "Nessuna risposta dal server"))
                }
            }
        }
        return response(responseSerializer: serializer, completionHandler: completionHandler)
    }
}
class BackendError : Error {
    var message : String?
    var cancelled : Bool = false
    init(cancelled : Bool) {
        self.cancelled = cancelled
    }
    init(message : String) {
        self.message = message
    }
}
