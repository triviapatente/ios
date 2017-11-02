//
//  ContactUsViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 02/11/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var motivationLabel: UITextField!
    @IBOutlet weak var messagePlaceholder: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var counterLabel: UILabel!
    
    // TODO: mettere quelli giusti
    let messageReasons = ["Suggerimento", "Segnalazione"]
    let maxMessageLength = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UITextField.appearance().tintColor = UIColor.lightText
        UITextView.appearance().tintColor = UIColor.lightText
        
        self.counterLabel.text = "\(self.maxMessageLength)"
        
        let motivationPicker = UIPickerView()
        motivationPicker.delegate = self
        motivationPicker.dataSource = self
        self.motivationLabel.inputView = motivationPicker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.messageReasons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.messageReasons[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.motivationLabel.text = self.messageReasons[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage()
    {

    }
    
    @IBAction func resignResponder()
    {
        self.messageTextView.resignFirstResponder()
        self.motivationLabel.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        return newText.characters.count <= self.maxMessageLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let msgLength = textView.text.characters.count
        self.counterLabel.text = "\(self.maxMessageLength - msgLength)"
        self.messagePlaceholder.isHidden = msgLength > 0
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
