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
    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        handler.randomNewGame { response in
            sleep(3)
            loadingView.hide(animated: true)
            print(response.game, response.opponent)
            if response.success == true {
                //TODO: go to game page
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
