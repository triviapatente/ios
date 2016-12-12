//
//  UILogoutViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 06/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class LogoutViewController: UIViewController {

    @IBOutlet var leaveButton : UIButton!
    @IBOutlet var remainButton : UIButton!
    
    var loadingView : MBProgressHUD!
    
    @IBAction func leave() {
        loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingView.mode = .indeterminate
        SessionManager.logout { response in
            self.loadingView.hide(animated: true)
            if response.success == true {
                self.fade()
            }
        }
    }
    @IBAction func remain() {
        self.fade()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leaveButton.mediumRounded()
        self.remainButton.mediumRounded()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
