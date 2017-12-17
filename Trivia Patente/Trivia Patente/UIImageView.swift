//
//  UIImageView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
    func load(path : URL?, placeholder : String, callback: ((UIImage?) -> Void)? = nil) {
        if let url = path {
            // NO CACHE PERCHE VIENE USATA QUELLA DI ALAMOFIRE
            let req = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
            self.af_setImage(withURLRequest: req, placeholderImage: UIImage(named: placeholder), runImageTransitionIfCached: false) { (response) in
                if let cb = callback {
                    cb(response.value)
                }
            }
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
    func clear() {
        self.layer.borderWidth = 0.0
        self.removeAllSubviews()
    }
    func load(user: User?) {
        self.contentMode = .scaleAspectFill
        self.layer.borderWidth = CGFloat(0) // for reausable views
        self.removeAllSubviews()

            let imagePath = user?.avatarImageUrl
            let url = getUrl(path: imagePath)
            
            if url != nil
            {
                self.load(path: url, placeholder: "default_avatar", callback: { image in
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
    func labelForUserInitials() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir Next", size: self.frame.width * 0.4)
//        label.backgroundColor = UIColor.red
        return label
    }
    func load(category: Category?) {
        let url = getUrl(path: category?.imagePath)
        
        self.load(path: url, placeholder: "")
    }
}
