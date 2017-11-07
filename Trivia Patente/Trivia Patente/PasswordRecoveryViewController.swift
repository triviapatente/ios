//
//  PasswordRecoveryViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 25/10/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class PasswordRecoveryViewController: UIViewController, UITextFieldDelegate {

    var nameField : TPInputView!
    var errorView : TPErrorView!
    
    @IBOutlet var resetButton : TPButton!
    @IBOutlet var errorViewContainer : UIView!
    
    let httpAuth = HTTPAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.layer.insertSublayer(Colors.accessGradientLayer(view: self.view), at: 0)
        
        self.resetButton.smallRounded()
        
        self.nameField.initValues(hint: "Username o email", delegate: self)
        self.nameField.add(target: self, changeValueHandler: #selector(checkValues))
    }
    
    func formIsCorrect() -> Bool {
        return nameField.isCorrect()
    }
    func enableValidation() {
        nameField.enableValidation()
    }
    func enableForm()
    {
        self.nameField.enable()
    }
    func disableForm()
    {
        self.nameField.disable()
    }
    @IBAction func resetPassword() {
        self.enableValidation()
        self.checkValues(vibrate: true)
        self.resignResponder()
        guard self.formIsCorrect() else {
            return
        }
        self.disableForm()
        self.resignResponder()
        self.resetButton.load()
        httpAuth.forgotPassword(username: nameField.getText()) { (response : TPForgotResponse) in
            self.resetButton.stopLoading()
            self.enableForm()
            self.handleResponse(response: response)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField.field:
            //programmatically touch login button
            resetButton.sendActions(for: .touchUpInside)
            break
        default: break
        }
        return true
    }
    
    func handleResponse(response : TPForgotResponse) {
        if response.success == true {
            NotificationCenter.default.post(name: Notification.Name("forgotMessage"), object: nil, userInfo: ["message": "Utilizza la nuova password che hai ricevuto per email per accedere."])
            self.dismissController()
        } else {
            self.setErrorMessage(message: response.message)
        }
    }
    
    func setErrorMessage(message: String)
    {
        self.errorViewContainer.isHidden = false
        self.errorView.set(error: message)
    }
    
    @IBAction func resignResponder() {
        _ = self.nameField.resignFirstResponder()
    }
    
    func checkValues(vibrate : Bool) {
        let username = nameField.getText()
        nameField.validate(condition: !username.isEmpty, error: "Inserisci l'username o l'email", vibrate: vibrate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissController()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let identifier = segue.identifier {
            switch identifier {
            case "username":
                self.nameField = destination as! TPInputView
                break
            case "error":
                self.errorView = destination as! TPErrorView
                break
            default: break
                
            }
        }
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
