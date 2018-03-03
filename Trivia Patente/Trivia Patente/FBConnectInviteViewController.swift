//
//  FBConnectInviteViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 27/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class FBConnectInviteViewController: BaseViewController {

    @IBOutlet var exitButton : UIButton!
    @IBOutlet var containerView : UIView!
    
    var isHidden : Bool! {
        didSet {
            self.view.isHidden = isHidden
        }
    }

    var delegate : FBConnectInviteDelegate!
    @IBAction func connect() {
        FBManager.link(sender: self) {[unowned self] (response) in
            guard self != nil else { return }
            if response.success == true {
                self.delegate.connected()
            }
        }
    }
    @IBAction func dismiss() {
        self.delegate.dismissed()
    }
    var canDismiss : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.mediumRounded()
        self.exitButton.isHidden = !canDismiss
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
