//
//  ShopResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 06/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPShopItemsResponse: TPResponse {
    var items : [Shopitem] = []
    
    override func load(json: JSON) {
        super.load(json: json)
        if let rawItems = json["items"].array {
            for item in rawItems {
                items.append(Shopitem(json: item))
            }
        }
    }
}
