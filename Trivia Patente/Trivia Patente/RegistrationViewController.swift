//
//  RegistrationViewController.swift
//  Trivia Patente
//
//  Created by Antonio Terpin on 05/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet var nameField : UITextField!
    @IBOutlet var emailField : UITextField!
    @IBOutlet var passwordField : UITextField!
    @IBOutlet var repeatPasswordField : UITextField!
    
    @IBOutlet var registerButton : TPButton!
    @IBOutlet var fbButton : TPButton!
    
    let http = HTTPAuth()
    
    @IBAction func normalRegistration() {
        let username = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        let repeatPassword = repeatPasswordField.text!
        guard !username.isEmpty else {
            fatalError("Not implemented")
        }
        guard !email.isEmpty else {
            fatalError("Not implemented")
        }
        guard !password.isEmpty else {
            fatalError("Not implemented")
        }
        guard !repeatPassword.isEmpty else {
            fatalError("Not implemented")
        }
        guard password == repeatPassword else {
            fatalError("Not implemented")
        }
        
        registerButton.load()
        http.register(username: username, email: email, password: password) { (response : TPAuthResponse) in
            self.registerButton.stopLoading()
            let alert = UIAlertController(title: "Response", message: response.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "indietro", style: .cancel, handler: nil))
            self.show(alert, sender: nil)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            emailField.becomeFirstResponder()
            break
        case emailField:
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            repeatPasswordField.becomeFirstResponder()
            break
        case repeatPasswordField:
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
        nameField.smallRounded()
        emailField.smallRounded()
        passwordField.smallRounded()
        repeatPasswordField.smallRounded()
        registerButton.smallRounded()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
