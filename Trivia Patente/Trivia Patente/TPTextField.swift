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
    var canCopyPaste = true
    override func becomeFirstResponder() -> Bool {
        alreadyFocused = true
        return super.becomeFirstResponder()
    }
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if !canCopyPaste {
            if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
                return false
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
