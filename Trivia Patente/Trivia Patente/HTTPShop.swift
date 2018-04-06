
//
//  HTTPShop.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 06/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class HTTPShop: HTTPManager {
    func shop_items(handler : @escaping (TPShopItemsResponse) -> Void) {
        _ = self.request(url: "/shop/list", method: .get, params: nil, handler: handler)
    }
}
