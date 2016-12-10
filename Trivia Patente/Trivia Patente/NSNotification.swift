//
//  NSNotification.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 10/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension NSNotification {
    func keyboardFrame(in view : UIView) -> CGRect? {
        let info  = self.userInfo!
        let value = info[UIKeyboardFrameEndUserInfoKey] as AnyObject
        if let rawFrame = value.cgRectValue {
            return view.convert(rawFrame, from: nil)
        }
        return nil
    }
}
