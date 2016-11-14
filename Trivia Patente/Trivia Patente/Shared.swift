//
//  Shared.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class Shared {
    static var categories : [Category]?
    static var preferences : Preferences? {
        didSet {
            print(preferences!.dictionaryRepresentation())
        }
    }
}
