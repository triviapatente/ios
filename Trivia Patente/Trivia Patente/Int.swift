//
//  Int.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 08/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension Int {
    func toSignedString() -> String {
        if self >= 0 {
            return "+\(self)"
        } else {
            return "\(self)"
        }
    }
}