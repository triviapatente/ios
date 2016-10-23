//
//  UIViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension UIViewController {
    class func root() -> UIViewController {
        if let _ = SessionManager.getToken() {
            return UIStoryboard.getFirstController(storyboard: "Main")
        } else {
            return UIStoryboard.getFirstController(storyboard: "FirstAccess")
        }
    }
}
