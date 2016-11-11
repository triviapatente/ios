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
        self.request(url: "/stats/detail/\(category.id!)", method: .get, params: nil, handler: handler)
    }
}
