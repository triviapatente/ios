//
//  LoginViewController.swift
//  Trivia Patente
//
//  Created by Antonio Terpin on 05/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
    var nameField : TPInputView!
    var passwordField : TPInputView!
    var errorView : TPErrorView!

    @IBOutlet var loginButton : TPButton!
    @IBOutlet var facebookButton : TPButton!
    @IBOutlet var errorViewContainer : UIView!
    
    let httpAuth = HTTPAuth()
    
    @IBAction func resignResponder() {
        _ = self.nameField.resignFirstResponder()
        _ = self.passwordField.resignFirstResponder()
    }
    
    func formIsCorrect() -> Bool {
        return nameField.isCorrect() && passwordField.isCorrect()
    }
    func enableValidation() {
        nameField.enableValidation()
        passwordField.enableValidation()
    }
    @IBAction func login() {
        self.enableValidation()
        self.checkValues()
        guard self.formIsCorrect() else {
            return
        }
        loginButton.load()
        httpAuth.login(user: nameField.getText(), password: passwordField.getText()) { (response : TPAuthResponse) in
            self.loginButton.stopLoading()
            self.handleResponse(response: response)
        }
    }
    func handleResponse(response : TPAuthResponse) {
        if response.success == true {
            let controller = UIViewController.root()
            self.present(controller, animated: true) {
                self.nameField.field.text = ""
                self.passwordField.field.text = ""
                self.errorViewContainer.isHidden = true
            }
        } else {
            self.errorView.set(error: response.message)
        }
    }
    func checkValues() {
        let username = nameField.getText()
        let password = passwordField.getText()
        
        nameField.validate(condition: !username.isEmpty, error: "Inserisci l'username o l'email")
        passwordField.validate(condition: !password.isEmpty, error: "Inserisci la password")
        
        loginButton.isEnabled = formIsCorrect()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case nameField.field:
                _ = passwordField.becomeFirstResponder()
                break
            case passwordField.field:
                //programmatically touch login button
                loginButton.sendActions(for: .touchUpInside)
                break
            default: break
        }
        return true
    }
    @IBAction func facebookLogin() {
        facebookButton.load()
        FBManager.login(sender: self) { response in
            self.facebookButton.stopLoading()
            self.handleResponse(response: response)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.smallRounded()
        
        self.nameField.initValues(hint: "Username o email", delegate: self)
        self.nameField.add(target: self, changeValueHandler: #selector(checkValues))
        
        self.passwordField.initValues(hint: "Password", delegate: self)
        self.passwordField.add(target: self, changeValueHandler: #selector(checkValues))
        self.passwordField.field.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let identifier = segue.identifier {
            switch identifier {
                case "username":
                    self.nameField = destination as! TPInputView
                    break
                case "password":
                    self.passwordField = destination as! TPInputView
                    break
                case "error":
                    self.errorView = destination as! TPErrorView
                    break
                default: break
                
            }
        }
    }

}
