//
//  FormViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 11/12/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import Foundation

class FormViewController : UIViewController
{
    var costantKeyboardTranslationRef = CGFloat(0.0)
    var shouldTranslate = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    func keyboardWillShow(notification:NSNotification){
        guard self.shouldTranslate else { return }
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        self.view.transform = CGAffineTransform(translationX: 0, y: -self.costantKeyboardTranslationRef)
    }
    
    func keyboardWillHide(notification:NSNotification){
        self.view.transform = CGAffineTransform(translationX: 0, y: 0)
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        theScrollView.contentInset = contentInset
    }
}
