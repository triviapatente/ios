//
//  RegistrationViewController.swift
//  Trivia Patente
//
//  Created by Antonio Terpin on 05/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    var nameField : TPInputView!
    var emailField : TPInputView!
    var passwordField : TPInputView!
    var repeatPasswordField : TPInputView!
    var errorView : TPErrorView!
    
    @IBOutlet var registerButton : TPButton!
    @IBOutlet var fbButton : TPButton!
    @IBOutlet var errorViewContainer : UIView!

    let http = HTTPAuth()
    
    @IBAction func resignResponder() {
        _ = self.nameField.resignFirstResponder()
        _ = self.emailField.resignFirstResponder()
        _ = self.passwordField.resignFirstResponder()
        _ = self.repeatPasswordField.resignFirstResponder()
    }
    
    func enableForm()
    {
        self.nameField.enable()
        self.passwordField.enable()
        self.repeatPasswordField.enable()
        self.emailField.enable()
    }
    func disableForm()
    {
        self.nameField.disable()
        self.passwordField.disable()
        self.repeatPasswordField.disable()
        self.emailField.disable()
    }
    
    func checkValues(vibrate : Bool = false) {
        let username = nameField.getText()
        let email = emailField.getText()
        let password = passwordField.getText()
        let repeatPassword = repeatPasswordField.getText()
        
        nameField.validate(condition: !username.isEmpty, error: "Inserisci l'username", vibrate: vibrate)
        emailField.validate(condition: email.isEmail && !email.isEmpty, error: "Inserisci un'indirizzo email corretto", vibrate: vibrate)
        passwordField.validate(condition: !password.isEmpty, error: "Inserisci la password", vibrate: vibrate)
        repeatPasswordField.validate(condition: !repeatPassword.isEmpty, error: "Reinserisci la password", vibrate: vibrate)
        repeatPasswordField.validate(condition: repeatPassword == password, error: "Le password non coincidono", vibrate: vibrate)
        
        registerButton.isEnabled = formIsCorrect()
    }
    func formIsCorrect() -> Bool {
        return nameField.isCorrect() && emailField.isCorrect() && passwordField.isCorrect() && repeatPasswordField.isCorrect()
    }
    
    func enableValidation() {
        nameField.enableValidation()
        emailField.enableValidation()
        passwordField.enableValidation()
        repeatPasswordField.enableValidation()
    }
    
    @IBAction func normalRegistration() {
        self.enableValidation()
        self.checkValues(vibrate: true)
        self.resignResponder()
        guard self.formIsCorrect() else {
            return
        }
        self.disableForm()
        registerButton.load()
        http.register(username: nameField.getText(), email: emailField.getText(), password: passwordField.getText()) { (response : TPAuthResponse) in
            self.enableForm()
            self.registerButton.stopLoading()
            self.handleResponse(response: response)
            
        }
    }
    func handleResponse(response : TPAuthResponse) {
        if response.success == true {
            let controller = UIViewController.root()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.changeRootViewController(with: controller)
//            self.present(controller, animated: true) {
//                self.clearForm()
//            }
        } else {
            self.errorView.set(error: response.message)
        }
    }
    func clearForm()
    {
        self.nameField.field.text = ""
        self.emailField.field.text = ""
        self.passwordField.field.text = ""
        self.repeatPasswordField.field.text = ""
        self.errorViewContainer.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField.field:
            _ = emailField.becomeFirstResponder()
            break
        case emailField.field:
            _ = passwordField.becomeFirstResponder()
            break
        case passwordField.field:
            _ = repeatPasswordField.becomeFirstResponder()
            break
        case repeatPasswordField.field:
            //programmatically touch login button
            registerButton.sendActions(for: .touchUpInside)
            break
        default: break
            
        }
        return true
    }
    @IBAction func facebookRegistration() {
        self.resignResponder()
        fbButton.load()
        FBManager.login(sender: self) { response in
            self.fbButton.stopLoading()
            self.handleResponse(response: response)
        }
    }
    @IBAction func showTermAndConditions()
    {
        self.showToast(text: Strings.terms_tap_toast)
    }
    @IBAction func userHasAnAccount()
    {
        self.resignResponder()
        NotificationCenter.default.post(name: Notification.Name("slideToLogin"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerButton.smallRounded()
        self.nameField.initValues(hint: "Username", delegate: self)
        self.nameField.add(target: self, changeValueHandler: #selector(RegistrationViewController.checkValues))

        self.emailField.initValues(hint: "Email", delegate: self)
        self.emailField.field.keyboardType = .emailAddress
        self.emailField.add(target: self, changeValueHandler: #selector(RegistrationViewController.checkValues))

        self.passwordField.initValues(hint: "Password", delegate: self)
        self.passwordField.field.isSecureTextEntry = true
        self.passwordField.add(target: self, changeValueHandler: #selector(RegistrationViewController.checkValues))
        
        self.repeatPasswordField.initValues(hint: "Ripeti password", delegate: self)
        self.repeatPasswordField.field.isSecureTextEntry = true
        self.repeatPasswordField.add(target: self, changeValueHandler: #selector(RegistrationViewController.checkValues))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let identifier = segue.identifier {
            switch identifier {
                case "username":
                    self.nameField = destination as! TPInputView
                    break
                case "email":
                    self.emailField = destination as! TPInputView
                    break
                case "password":
                    self.passwordField = destination as! TPInputView
                    break
                case "repeat_password":
                    self.repeatPasswordField = destination as! TPInputView
                    break
                case "error":
                    self.errorView = destination as! TPErrorView
                    break
                default: break
            
            }
        }
    }

}
