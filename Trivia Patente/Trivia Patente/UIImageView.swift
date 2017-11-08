//
//  UIImageView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    func load(path : URL?, placeholder : String) {
        self.image = UIImage(named: placeholder)
        if let url = path {
            let headers = HTTPManager.getAuthHeaders(auth: true)
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData(completionHandler: { response in
                if let data = response.result.value {
                    self.image = UIImage(data: data)
                }
            })
        }
    }
    func getUrl(path : String?) -> URL? {
        var url : URL? = nil
        if let image = path {
            url = URL(string: image)
        }
        return url
    }
    func load(quiz : Quiz?) {
        let path = quiz?.imagePath
        let url = getUrl(path: path)
        self.load(path: url, placeholder: "")
        
    }
    func load(user: User?) {
        let imagePath = user!.image != nil ? HTTPManager.getBaseURL() + "/" + (user?.image)! : nil
        let url = getUrl(path: imagePath)

        self.load(path: url, placeholder: "default_avatar")
    }
    func load(category: Category?) {
        let url = getUrl(path: category?.imagePath)
        
        self.load(path: url, placeholder: "")
    }
}
