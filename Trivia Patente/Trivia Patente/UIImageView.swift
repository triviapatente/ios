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
            Alamofire.download(url).downloadProgress(closure: { (progress : Progress) in
                //TODO: add circular animation
                
                print("Download Progress: \(progress.fractionCompleted)")
            }).responseData(completionHandler: { response in
                if let data = response.result.value {
                    self.image = UIImage(data: data)
                }
            })
        }
    }
    func loadAvatar(user: User) {
        var url : URL? = nil
        if let image = user.image {
            url = URL(string: image)
        }
        self.load(path: url, placeholder: "default_avatar")
    }
}
