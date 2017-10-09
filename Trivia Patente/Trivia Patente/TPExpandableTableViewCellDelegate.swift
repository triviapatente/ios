//
//  TPRecentTableViewCellDelegate.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

protocol TPExpandableTableViewCellDelegate {
    func remove(item : Base)
    func select(item : Base)
    func add(item : Base, position : Int?)
    func search(item: Base) -> Int?
}
