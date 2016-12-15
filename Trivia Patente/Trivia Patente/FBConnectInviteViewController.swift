//
//  FBConnectInviteViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 27/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class FBConnectInviteViewController: UIViewController {

    @IBOutlet var exitButton : UIButton!
    @IBAction func connect() {
        print("connect")
    }
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    var canDismiss : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.mediumRounded()
        self.exitButton.isHidden = !canDismiss
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
