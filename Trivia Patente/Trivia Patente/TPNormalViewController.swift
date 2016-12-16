//
//  TPNormalViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 16/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPNormalViewController: UIViewController {
    

    override func viewDidAppear(_ animated: Bool) {
        if let _ = SessionManager.getToken() {
            SocketGame.leave(type: "game")
        }
        super.viewDidAppear(animated)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
