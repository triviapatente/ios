//
//  ChangePasswordViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 16/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class ChangePasswordViewController: FormViewController, UITextFieldDelegate {

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
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = SessionManager.getToken() {
            SocketGame.leave(type: "game")
        }
        super.viewDidAppear(animated)
        (self.navigationController as! TPNavigationController).setUser(candidate: SessionManager.currentUser, with_title: false)
    }
    
    func formIsCorrect() -> Bool {
        print(oldPasswordField.isCorrect())
        print(newPasswordField.isCorrect())
        print(repeatPasswordField.isCorrect())
        return oldPasswordField.isCorrect() && newPasswordField.isCorrect() && repeatPasswordField.isCorrect()
    }
    func enableValidation() {
        oldPasswordField.enableValidation()
        newPasswordField.enableValidation()
        repeatPasswordField.enableValidation()
    }
    
    @IBAction func changePassword() {
        self.enableValidation()
        self.checkValues(vibrate: true)
        guard self.formIsCorrect() else {
            return
        }
        self.view.endEditing(true)
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
    
    func checkValues(vibrate : Bool) {
        let oldPassword = self.oldPasswordField.getText()
        let newPassword = self.newPasswordField.getText()
        let repeatPassword = self.repeatPasswordField.getText()
        
        oldPasswordField.validate(condition: !oldPassword.isEmpty, error: "Inserisci l'username o l'email", vibrate: vibrate)
        newPasswordField.validate(condition: newPassword != oldPassword, error: "La nuova e la vecchia password sono identiche", vibrate: vibrate)
        newPasswordField.validate(condition: newPassword.count >= Constants.passwordMinLength, error: "La password deve contenere almeno 7 caratteri", vibrate: vibrate)
        repeatPasswordField.validate(condition: repeatPassword == newPassword, error: "Le password non coincidono", vibrate: vibrate)
        
//        confirmButton.isEnabled = formIsCorrect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.smallRounded()
        initFields()
        self.setDefaultBackgroundGradient()
        self.costantKeyboardTranslationRef = 50.0
        self.navigationItem.rightBarButtonItems = []
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
    
    @IBAction func resignResponders()
    {
        _ = self.oldPasswordField.resignFirstResponder()
        _ = self.newPasswordField.resignFirstResponder()
        _ = self.repeatPasswordField.resignFirstResponder()
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
