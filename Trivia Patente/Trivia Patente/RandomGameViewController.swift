//
//  RandomGameViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class RandomGameViewController: UIViewController {

    let handler = HTTPGame()
    var response : TPNewGameResponse!
    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        handler.randomNewGame { response in
            sleep(3)
            loadingView.hide(animated: true)
            self.response = response
            if response.success == true {
                //TODO: invite    
            } else {
                //TODO: add error handler
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
