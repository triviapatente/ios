//
//  UIImageView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

extension UIImageView {
    func load(path : URL?, placeholder : String, callback: ((UIImage?) -> Void)? = nil) {
        if let url = path {
//            URLCache.shared.removeAllCachedResponses()
//            if let cache = UIImageView.af_sharedImageDownloader.imageCache {
//                cache.removeAllImages()
//            }
//            self.image = UIImage(named: placeholder)
//            let task = URLSession.shared.dataTask(with: req, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
//                if let bytes = data, let httpResponse = response as? HTTPURLResponse {
//                    print(httpResponse.allHeaderFields)
//                    DispatchQueue.main.async {
//                        self.image = UIImage(data: bytes)
//                        if let cb = callback {
//                            cb(self.image)
//                        }
//                    }
//                }
//            })
//            task.resume()
//            self.af_setImage(withURLRequest: req, placeholderImage: UIImage(named: placeholder), runImageTransitionIfCached: false) {  (response) in
//            guard self != nil else { return }
//                if let cache = UIImageView.af_sharedImageDownloader.imageCache, let image = response.value {
//                    cache.add(image, for: req, withIdentifier: nil)
//                }
//            }
            self.sd_cancelCurrentImageLoad()
            self.sd_cancelCurrentAnimationImagesLoad()
            self.sd_setImage(with: url, placeholderImage: UIImage(named: placeholder), completed: { (image, error, cacheType, url) in
                if error != nil, let _ = image {
                    if let cb = callback {
                        cb(image!)
                    }
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
    func clear() {
        self.layer.borderWidth = 0.0
        self.removeAllSubviews()
        self.sd_cancelCurrentImageLoad()
    }
    func load(user: User?) {
        self.contentMode = .scaleAspectFill
        self.clear()

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
