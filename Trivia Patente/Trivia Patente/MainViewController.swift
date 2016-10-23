//
//  MainViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD
class MainViewController: UIViewController {
    var loadingView : MBProgressHUD!
    
    let socketAuth = SocketAuth()
    override func viewDidLoad() {
        super.viewDidLoad()
        connectToSocket()
        // Do any additional setup after loading the view.
    }
    func connectToSocket() {
        loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingView.mode = .indeterminate
        SessionManager.authenticateSocket { (response : TPResponse?) in
            self.loadingView.hide(animated: true)
            if response?.success != true {
                SessionManager.drop()
                let controller = UIViewController.root()
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    func goToFirstAccess() {
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
