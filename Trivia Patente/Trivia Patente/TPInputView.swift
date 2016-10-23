//
//  TPInputView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import QuartzCore

class TPInputView: UIViewController {
    
    @IBOutlet var field : TPTextField!
    @IBOutlet var errorView : UILabel!
    var isError : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func isCorrect() -> Bool {
        return !isError
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.field.layer.borderWidth = 1
        if isError == false {
            self.normalState()
        }
        
    }
    func validate(condition : Bool, error : String) {
        //if an edittext has never been touched by the user, why display errors?
        if !field.alreadyFocused || field.isEditing || condition {
            normalState()
        } else {
            errorState(error: error)
        }
    }
    func errorState(error : String) {
        isError = true
        self.errorView.smallRounded(corners: [.topLeft, .topRight])
        self.field.smallRounded(corners: [.bottomLeft, .bottomRight])
        self.errorView.text = error
        self.errorView.isHidden = false
        self.field.layer.borderColor = UIColor.red.cgColor
    }
    func normalState() {
        isError = false
        self.field.smallRounded()
        self.errorView.isHidden = true
        self.field.layer.borderColor = UIColor.clear.cgColor
    }
    func getText() -> String {
        return field.text!
    }
    func initValues(hint : String, delegate : UITextFieldDelegate) {
        self.field.placeholder = hint
        self.field.delegate = delegate
    }
    override func becomeFirstResponder() -> Bool {
        _ = self.field.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
}
