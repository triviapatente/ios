//
//  File.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 10/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import Foundation

protocol GCStackViewDelegate {
    func stackView(stackViewController: GCStackViewController, didDisplayItemAt index: Int)
    func stackView(stackViewController: GCStackViewController, willDisplayItemAt index: Int)
}
