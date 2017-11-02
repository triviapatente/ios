//
//  AlphaViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 27/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class AlphaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        (self.navigationController as! TPNavigationController).setUser(candidate: SessionManager.currentUser)
        self.set(backgroundGradientColors: [Colors.primary.cgColor, Colors.secondary.cgColor])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
