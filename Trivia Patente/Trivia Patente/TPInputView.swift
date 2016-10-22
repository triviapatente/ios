//
//  TPInputView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import QuartzCore

class TPInputView: TPView {
    
    @IBOutlet var field : UITextField!
    @IBOutlet var errorView : UITextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.normalState()
    }
    func errorState(error : String) {
        self.errorView.text = error
        self.errorView.layer.cornerRadius = 5
        self.errorView.isHidden = false
        self.field.layer.borderColor = UIColor.clear.cgColor
    }
    func normalState() {
        self.errorView.isHidden = true
        self.field.layer.borderColor = UIColor.red.cgColor
    }
}
