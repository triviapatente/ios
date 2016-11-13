//
//  HTTPStats.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class HTTPStats: HTTPManager {
    func category_stats(category : Category, handler : @escaping (TPStatsDetailResponse) -> Void) {
        var url = "/stats/detail/"
        if let id = category.id {
            url += "\(id)"
        }
        self.request(url: url, method: .get, params: nil, handler: handler)
    }
}
