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
            let tpResponse = T(object: data, statusCode: response!.statusCode)
            if tpResponse.success == true {
                return .success(tpResponse)
            } else {
                return .failure(tpResponse.message as! Error)
            }
        }
        return response(responseSerializer: serializer, completionHandler: completionHandler)
    }
}
