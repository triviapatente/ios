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
    func load(path : URL?, placeholder : String, callback: ((UIImage?) -> Void)? = nil) {
        self.image = UIImage(named: placeholder)
        if let url = path {
            UIImage.downloadImage(url: url, callback: { (image) in
                self.image = image
                if let cb = callback {
                    cb(self.image)
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
        if let avatar = user?.savedImaged {
            self.image = avatar
        } else {
            let imagePath = user?.avatarImageUrl
            let url = getUrl(path: imagePath)
            self.load(path: url, placeholder: "default_avatar", callback: { image in
                user!.savedImaged = image
                if (user?.isMe())! {
                    SessionManager.set(user: user!)
                }
            })
        }
    }
    func load(category: Category?) {
        let url = getUrl(path: category?.imagePath)
        
        self.load(path: url, placeholder: "")
    }
}
