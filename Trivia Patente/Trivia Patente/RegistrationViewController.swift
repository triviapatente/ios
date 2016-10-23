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
    
    @IBOutlet var registerButton : TPButton!
    @IBOutlet var fbButton : TPButton!
    
    let http = HTTPAuth()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let username = nameField.getText()
        let email = emailField.getText()
        let password = passwordField.getText()
        let repeatPassword = repeatPasswordField.getText()
        
        nameField.validate(condition: !username.isEmpty, error: "Inserisci l'username")
        emailField.validate(condition: !email.isEmpty, error: "Inserisci l'email")
        passwordField.validate(condition: !password.isEmpty, error: "Inserisci la password")
        repeatPasswordField.validate(condition: !repeatPassword.isEmpty, error: "Reinserisci la password")
        repeatPasswordField.validate(condition: repeatPassword == password, error: "Le password non coincidono")
        
        registerButton.isEnabled = nameField.isCorrect() && emailField.isCorrect() && passwordField.isCorrect() && repeatPasswordField.isCorrect()
        fbButton.isEnabled = registerButton.isEnabled
    }
    
    @IBAction func normalRegistration() {
        
        registerButton.load()
        http.register(username: nameField.getText(), email: emailField.getText(), password: passwordField.getText()) { (response : TPAuthResponse) in
            self.registerButton.stopLoading()
            if response.success == true {
                let controller = UIViewController.root()
                self.present(controller, animated: true, completion: nil)
            } else {
                MBProgressHUD.error(response.message!, view: self.view)

            }
        }
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
        fbButton.load()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameField.initValues(hint: "Username", delegate: self)
        self.emailField.initValues(hint: "Email", delegate: self)
        self.passwordField.initValues(hint: "Password", delegate: self)
        self.repeatPasswordField.initValues(hint: "Ripeti password", delegate: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TPInputView {
            if let identifier = segue.identifier {
                switch identifier {
                    case "username":
                        self.nameField = destination
                        break
                    case "email":
                        self.emailField = destination
                        break
                    case "password":
                        self.passwordField = destination
                        break
                    case "repeat_password":
                        self.repeatPasswordField = destination
                        break
                    default: break
            
                }
            }
        }
    }

}
