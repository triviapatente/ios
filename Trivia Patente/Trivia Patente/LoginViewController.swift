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
    @IBOutlet var nameField : UITextField!
    @IBOutlet var passwordField : UITextField!
    @IBOutlet var loginButton : TPButton!
    @IBOutlet var facebookButton : TPButton!
    
    let httpAuth = HTTPAuth()
    
    @IBAction func login() {
        let username = nameField.text!
        let password = passwordField.text!
        
        guard !username.isEmpty else {
            fatalError("Not implemented")
        }
        guard !password.isEmpty else {
            fatalError("Not implemented")
        }
        loginButton.load()
        httpAuth.login(user: username, password: password) { (response : TPAuthResponse) in
            self.loginButton.stopLoading()
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
        case nameField:
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            //programmatically touch login button
            loginButton.sendActions(for: .touchUpInside)
            break
        default: break
            
        }
        return true
    }
    @IBAction func facebookLogin() {
        facebookButton.load()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.smallRounded()
        passwordField.smallRounded()
        loginButton.smallRounded()

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
