//
//  UITextView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 10/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension UITextView {
    func requiredHeight(for maxLines : Int = 0) -> CGFloat {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let textView = UITextView(frame: frame)
        textView.textContainer.maximumNumberOfLines = maxLines
        textView.contentInset = self.contentInset
        textView.attributedText = self.attributedText
        textView.sizeToFit()
        return textView.frame.height
    }
}
