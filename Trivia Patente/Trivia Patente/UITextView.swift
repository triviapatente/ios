//
//  UITextView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 10/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension UITextView {
    var requiredHeight : CGFloat {
        get {
            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
            let textView = UITextView(frame: frame)
            textView.contentInset = self.contentInset
            textView.font = self.font
            textView.text = self.text
            textView.sizeToFit()
            return textView.frame.height
        }
    }
}
