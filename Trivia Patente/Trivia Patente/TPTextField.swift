//
//  TPTextField.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPTextField : UITextField {
    var alreadyFocused  = false
    override func becomeFirstResponder() -> Bool {
        alreadyFocused = true
        return super.becomeFirstResponder()
    }
}
