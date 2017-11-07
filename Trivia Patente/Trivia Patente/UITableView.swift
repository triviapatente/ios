//
//  IndexPath.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 27/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension UITableView {

    func scrollToTop() {
        let path = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: path, at: .top, animated: true)
    }
}
