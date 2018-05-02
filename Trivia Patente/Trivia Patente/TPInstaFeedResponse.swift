//
//  TPInstaFeedResponse.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 02/05/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import Foundation
import SwiftyJSON

class InstaPost {
    var url : String!
    var postLink : String!
    var type :InstaPostType!
    
    init(json: JSON) {
        self.url = json["url"].stringValue
        self.postLink = json["link"].stringValue
        self.type = InstaPostType(rawValue: json["type"].stringValue)
    }
}

enum InstaPostType : String {
    case image = "image"
    case video = "video"
}

class TPInstaFeedResponse : TPResponse {
    var posts : [InstaPost]? = nil
    
    override func load(json : JSON) {
        super.load(json: json)
        if let images = json["images"].array {
            posts = [InstaPost]()
            posts!.removeAll()
            for p in 0..<images.count {
                let post = InstaPost(json: images[p])
                if post.type == .image {
                    posts!.append(post)
                }
            }
            
        }
    }
}
