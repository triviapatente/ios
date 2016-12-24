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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.mediumRounded()
    }
    var container : UIView? {
        get {
            return self.view.superview
        }
    }
    func set(error : String) {
        errorTextView.text = error
        UIView.animate(withDuration: 0.2, animations: {
            self.container!.isHidden = false
        }) { completed in
            self.view.shake()
        }
    }
    
}
