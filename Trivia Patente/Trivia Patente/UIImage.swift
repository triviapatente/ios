//
//  UIImage.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 08/11/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension UIImage
{
    class func downloadImage(url: URLConvertible?, auth: Bool = true, callback: @escaping ((UIImage?)->Void)) {
        guard url != nil else { return }
        var headers : HTTPHeaders?
        if auth {
            headers = HTTPManager.getAuthHeaders(auth: true)
        }
//        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData(completionHandler: { response in
//            if let data = response.result.value {
//                let image = UIImage(data: data)
//                callback(image)
//            } else {
//                callback(nil)
//            }
//        })
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseImage { response in
            if let image = response.result.value {
                callback(image)
            } else {
                callback(nil)
            }
        }
    }
}
