//
//  GCStackViewDataSource.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 10/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import Foundation

protocol GCStackViewDataSource {
    func numberOfItems() -> Int
    func configureViewForItem(itemView: UIView, index: Int) -> UIView
}
