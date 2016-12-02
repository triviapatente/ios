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
            loadingView.hide(animated: true)
            self.response = response
            if response.success == true {
                //TODO: invite    
                self.performSegue(withIdentifier: "wait_opponent_segue", sender: self)
            } else {
                //TODO: add error handler
            }
        }

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wait_opponent_segue" {
            let destination = segue.destination as! WaitOpponentViewController
            self.response.game.opponent = self.response.opponent
            destination.game = self.response.game
            destination.fromInvite = true
        }
    }
    

}
