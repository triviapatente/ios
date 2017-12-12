//
//  LoginViewController.swift
//  Trivia Patente
//
//  Created by Antonio Terpin on 05/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: FormViewController, UITextFieldDelegate {
    var nameField : TPInputView!
    var passwordField : TPInputView!
    var errorView : TPErrorView!

    @IBOutlet var loginButton : TPButton!
//    @IBOutlet var facebookButton : TPButton!
    @IBOutlet var errorViewContainer : UIView!
    @IBOutlet var forgotPasswordButton : UIButton!
    
    let httpAuth = HTTPAuth()
    
    @IBAction func forgotPassword() {
        
    }
    
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
    func enableForm()
    {
        self.nameField.enable()
        self.passwordField.enable()
    }
    func disableForm()
    {
        self.nameField.disable()
        self.passwordField.disable()
    }
    @IBAction func login() {
        self.enableValidation()
        self.checkValues(vibrate: true)
        self.resignResponder()
        guard self.formIsCorrect() else {
            return
        }
        self.disableForm()
        self.resignResponder()
        loginButton.load()
        httpAuth.login(user: nameField.getText(), password: passwordField.getText()) { (response : TPAuthResponse) in
            self.loginButton.stopLoading()
            self.enableForm()
            self.forgotPasswordButton.isHidden = response.success
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
//                self.errorViewContainer.isHidden = true
//            }
        } else {
            self.errorView.set(error: response.message)
        }
    }
    func checkValues(vibrate : Bool) {
        let username = nameField.getText()
        let password = passwordField.getText()
        nameField.normalState()
        passwordField.normalState()
        nameField.validate(condition: !username.isEmpty, error: "Inserisci l'username o l'email", vibrate: vibrate)
        passwordField.validate(condition: !password.isEmpty, error: "Inserisci la password", vibrate: vibrate)
        
//        loginButton.isEnabled = formIsCorrect()
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
//    @IBAction func facebookLogin() {
//        self.resignResponder()
//        facebookButton.load()
//        FBManager.login(sender: self) { response in
//            self.facebookButton.stopLoading()
//            self.handleResponse(response: response)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.smallRounded()
        
        self.costantKeyboardTranslationRef = 30.0
        
        self.nameField.initValues(hint: "Username o email", delegate: self)
        self.nameField.add(target: self, changeValueHandler: #selector(checkValues))
        
        self.passwordField.initValues(hint: "Password", delegate: self)
        self.passwordField.add(target: self, changeValueHandler: #selector(checkValues))
        self.passwordField.field.isSecureTextEntry = true
        // Do any additional setup after loading the view.
        
        // Listen for an error message from the forgot password controller
        NotificationCenter.default.addObserver(self, selector: #selector(handleForgotNotification), name: Notification.Name("forgotMessage"), object: nil)
    }
    
    func handleForgotNotification(notification: Notification)
    {
        self.errorViewContainer.isHidden = false
        self.errorView.set(error: notification.userInfo!["message"] as! String)
        self.clearForm()
        self.enableForm()
        self.loginButton.stopLoading()
    }
    
    func clearForm()
    {
        self.nameField.field.text = ""
        self.passwordField.field.text = ""
    }
    
    @IBAction func showTermsAndPrivacy() {
        ContactUsViewController.handleTerms(controller: self)
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
