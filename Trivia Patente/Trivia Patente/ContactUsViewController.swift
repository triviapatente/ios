//
//  ContactUsViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 02/11/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var motivationField: TPTextField!
    @IBOutlet weak var messagePlaceholder: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    // TODO: mettere quelli giusti
    let messageReasons = [("Suggerimento","hint"), ("Segnalazione errore","complaint"), ("Altro","other")]
    var selectedReasonIndex = 0
    let maxMessageLength = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UITextField.appearance().tintColor = UIColor.clear
        UITextView.appearance().tintColor = UIColor.lightText
        
        self.counterLabel.text = "\(self.maxMessageLength)"
        
        let motivationPicker = UIPickerView()
        motivationPicker.delegate = self
        motivationPicker.dataSource = self
        self.motivationField.inputView = motivationPicker
        self.motivationField.canCopyPaste = false
    }
    
    @IBAction func openMotivationSelector()
    {
        _ = self.motivationField.becomeFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.messageReasons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.messageReasons[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.motivationField.text = self.messageReasons[row].0
        self.selectedReasonIndex = row
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage()
    {
        guard (self.messageTextView.text.characters.count > 0 && !String.blank(text: self.messageTextView.text)) else
        {
            self.showToast(text: Strings.empty_message_toast)
            return
        }
        
        self.resignResponder()
        let httpManager = HTTPManager()
        self.showToast(text: "Invio...")
        httpManager.request(url: "/ws/contact", method: .post, params: ["message":self.messageTextView.text!, "scope":self.messageReasons[selectedReasonIndex].1], auth: true) { (response: TPResponse) in
            if response.success && response.statusCode == 200 {
                self.showToast(text: "Messaggio inviato")
                self.clearForm()
            } else
            {
                self.showToast(text: "Errore durante l'invio. Riprova")
            }
        }
    }
    
    func clearForm()
    {
        self.messageTextView.text = ""
        self.messagePlaceholder.isHidden = false
        self.textViewDidChange(self.messageTextView)
    }
    
    @IBAction func resignResponder()
    {
        self.messageTextView.resignFirstResponder()
        self.motivationField.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        return newText.characters.count <= self.maxMessageLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let msgLength = textView.text.characters.count
        self.counterLabel.text = "\(self.maxMessageLength - msgLength)"
        self.messagePlaceholder.isHidden = msgLength > 0
        let trimmedText = textView.text.trimmingCharacters(in: .newlines)
        if textView.text != trimmedText
        {
            textView.text = trimmedText
        }
//        self.sendButton.isEnabled = msgLength > 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return self.messageReasons.map({ t in
            t.0
        }).index(of: newText) != nil
    }
    
    @IBAction func termsTapped()
    {
        self.showToast(text: Strings.terms_tap_toast)
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
