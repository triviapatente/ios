//
//  UITableViewCell.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 15/02/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import Foundation

extension UITableViewCell {
    var tableView: UITableView? {
        return self.parentView(of: UITableView.self)
    }
}

extension UICollectionViewCell {
    var tableView: UICollectionView? {
        return self.parentView(of: UICollectionView.self)
    }
}
