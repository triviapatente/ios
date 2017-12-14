//
//  TPErrorView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 25/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation
import UIKit

class TPErrorView : UIViewController {
    @IBOutlet var errorTextView : TPTextView!
    private var errorStringQueue : String = ""
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.mediumRounded()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorTextView.text = self.errorStringQueue
    }
    var container : UIView? {
        get {
            return self.view.superview
        }
    }
    func clearError() {
        self.container!.isHidden = true
    }
    func set(error : String) {
        if errorTextView == nil { // view not istantiated yet
            self.errorStringQueue = error
            return
        }
        errorTextView.text = error
        UIView.animate(withDuration: 0.2, animations: {
            self.container!.isHidden = false
        }) { completed in
            self.view.shake()
        }
    }
    
}
