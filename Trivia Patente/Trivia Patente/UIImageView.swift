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
            Alamofire.request(url).responseData(completionHandler: { response in
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
        let url = getUrl(path: user?.image)

        self.load(path: url, placeholder: "default_avatar")
    }
    func load(category: Category?) {
        let url = getUrl(path: category?.imagePath)
        
        self.load(path: url, placeholder: "")
    }
}
