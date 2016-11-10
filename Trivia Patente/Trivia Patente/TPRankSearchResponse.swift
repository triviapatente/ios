//
//  TPRankSearchResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 10/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRankSearchResponse: TPResponse {
    var users : [User] = []
    override func load(json: JSON) {
        super.load(json: json)
        if let rawUsers = json["matches"].array {
            for item in rawUsers {
                users.append(User(json: item))
            }
        }
    }
    func limitToFit(in tableView : UITableView) {
        guard tableView.rowHeight > 0 else { return }
        var height = tableView.frame.size.height
        if let header = tableView.tableHeaderView {
            height -= header.frame.size.height
        }
        let dimension = height / tableView.rowHeight
        let limit = Int(dimension)
        self.users.removeSubrange(limit..<self.users.count)
    }
}
