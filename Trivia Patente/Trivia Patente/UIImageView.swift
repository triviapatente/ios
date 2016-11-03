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
    func loadAvatar(candidate: User?) {
        var url : URL? = nil
        if let image = candidate?.image {
            url = URL(string: image)
        }
        self.load(path: url, placeholder: "default_avatar")
    }
}
