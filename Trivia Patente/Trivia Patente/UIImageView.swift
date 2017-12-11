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
        self.contentMode = .scaleAspectFill
        self.layer.borderWidth = CGFloat(0) // for reausable views
        self.removeAllSubviews()
        if let avatar = user?.savedImaged {
            self.image = avatar
        } else {
            let imagePath = user?.avatarImageUrl
            let url = getUrl(path: imagePath)
            
            if url != nil
            {
                self.load(path: url, placeholder: "default_avatar", callback: { image in
                    user!.savedImaged = image
                    if (user?.isMe())! {
                        SessionManager.set(user: user!)
                    }
                })
            } else
            {
                self.image = UIImage(named: "no_image_bg")
                self.layer.borderColor = UIColor.white.cgColor
                self.layer.borderWidth = CGFloat(1)
                // add initials label
                let label = self.labelForUserInitials()
                label.text = user!.initials.uppercased()
                self.addSubview(label)
            }
        }
    }
    func labelForUserInitials() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir Next", size: self.frame.width * 0.5)
        return label
    }
    func load(category: Category?) {
        let url = getUrl(path: category?.imagePath)
        
        self.load(path: url, placeholder: "")
    }
}
