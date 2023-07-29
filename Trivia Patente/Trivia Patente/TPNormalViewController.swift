//
//  TPNormalViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 16/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPNormalViewController: BaseViewController, TPViewController {
    
    func needsMenu() -> Bool {
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = SessionManager.getToken() {
            SocketGame.leave(type: "game")
        }
        super.viewDidAppear(animated)
        (self.navigationController as! TPNavigationController).setUser(candidate: SessionManager.currentUser, with_title: false)
    }

}
