//
//  TPRecentTableViewCellDelegate.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

protocol TPExpandableTableViewCellDelegate {
    func removeCell(for item : Base)
    func selectCell(for item : Base)
}
