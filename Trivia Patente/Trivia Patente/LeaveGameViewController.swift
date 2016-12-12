//
//  LeaveGameViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class LeaveGameViewController: UIViewController {
    @IBOutlet var containerView : UIView!
    @IBOutlet var decrementLabel : UILabel!
    @IBOutlet var dismissButton : UIButton!
    @IBOutlet var leaveButton : UIButton!
    
    var game : Game!
    
    let handler = HTTPGame()
    
    var sender : TPGameActions!
    
    @IBAction func buttonTapped(button : UIButton) {
        if button == dismissButton {
            self.fade()
        } else if button == leaveButton {
            handler.leave_game(game_id: game.id!) { response in
                if response.success == true {
                    self.fade()
                    self.sender.performSegue(withIdentifier: "round_details", sender: self)
                } else {
                    //TODO: error handler
                }
            }
        }
    }
    func getDecrement() {
        handler.get_leave_decrement(game_id: game.id!) { response in
            if response.success == true {
                self.decrementLabel.text = "\(response.decrement!)"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissButton.mediumRounded()
        self.leaveButton.mediumRounded()
        self.containerView.mediumRounded()
        self.getDecrement()
    }

    

}
