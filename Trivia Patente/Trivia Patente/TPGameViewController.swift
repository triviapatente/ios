//
//  TPGameViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 16/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPGameViewController: BaseViewController {
    //defaults to true (on dismiss, it goes to mainviewcontroller)
    var mainOnDismiss : Bool {
        return true
    }
    override func needsMenu() -> Bool {
        return false
    }
    func join_room() {
        
    }
}
