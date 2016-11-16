//
//  ChangePasswordViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 16/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    var oldPasswordField : TPInputView!
    var newPasswordField : TPInputView!
    var repeatPasswordField : TPInputView!
    var errorView : TPErrorView!
    var errorViewContainer : UIView? {
        get {
            return errorView.view.superview
        }
    }

    
    let handler = HTTPAuth()
    
    @IBOutlet var confirmButton : TPButton!
    
    
    func formIsCorrect() -> Bool {
        return oldPasswordField.isCorrect() && newPasswordField.isCorrect() && repeatPasswordField.isCorrect()
    }
    func enableValidation() {
        oldPasswordField.enableValidation()
        newPasswordField.enableValidation()
        repeatPasswordField.enableValidation()
    }
    
    @IBAction func changePassword() {
        self.enableValidation()
        self.checkValues()
        guard self.formIsCorrect() else {
            return
        }
        
        let old = oldPasswordField.getText()
        let new = newPasswordField.getText()
        confirmButton.load()
        handler.changePassword(old: old, new: new) { response in
            self.confirmButton.stopLoading()
            if response.success == true {
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.errorView.set(error: response.message)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case oldPasswordField.field:
                _ = newPasswordField.becomeFirstResponder()
                break
            case newPasswordField.field:
                _ = repeatPasswordField.becomeFirstResponder()
                break
            case repeatPasswordField.field:
                //programmatically touch login button
                confirmButton.sendActions(for: .touchUpInside)
            break
            default: break
        }
        return true
    }
    
    func checkValues() {
        let oldPassword = self.oldPasswordField.getText()
        let newPassword = self.newPasswordField.getText()
        let repeatPassword = self.repeatPasswordField.getText()
        
        oldPasswordField.validate(condition: !oldPassword.isEmpty, error: "Inserisci l'username o l'email")
        newPasswordField.validate(condition: !newPassword.isEmpty, error: "Inserisci la password")
        repeatPasswordField.validate(condition: repeatPassword == newPassword, error: "Le password non coincidono")
        
        confirmButton.isEnabled = formIsCorrect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.smallRounded()
        initFields()
    }
    func initFields() {
        let hints = ["Password precedente", "Nuova password", "Ripeti password"]
        let fields = [self.oldPasswordField, self.newPasswordField, self.repeatPasswordField]
        for i in 0..<fields.count {
            let field = fields[i]!, hint = hints[i]
            field.initValues(hint: hint, delegate: self)
            field.add(target: self, changeValueHandler: #selector(checkValues))
            field.field.isSecureTextEntry = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "old_password":
                    self.oldPasswordField = segue.destination as! TPInputView
                    break
                case "new_password":
                    self.newPasswordField = segue.destination as! TPInputView
                    break
                case "repeat_password":
                    self.repeatPasswordField = segue.destination as! TPInputView
                    break
                case "error_view":
                    self.errorView = segue.destination as! TPErrorView
                    break
                default: break
            }
        }
    }

}
