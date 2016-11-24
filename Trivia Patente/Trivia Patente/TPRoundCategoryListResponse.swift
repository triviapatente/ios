//
//  TPRoundCategoryListResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRoundCategoryListResponse: TPResponse {
    var categories : [Category] = []
    override func load(json: JSON) {
        super.load(json: json)
        if let rawCategories = json["categories"].array {
            for item in rawCategories {
                categories.append(Category(json: item))
            }
        }
    }
}
