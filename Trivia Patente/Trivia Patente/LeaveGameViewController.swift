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
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var arrowView: UIImageView!
    
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
                    self.game.ended = true
                    self.sender.gameCancelled = true
                    self.sender.performSegue(withIdentifier: "round_details", sender: self)
                } else {
                    self.showGenericError()
                }
            }
        }
    }
    func getDecrement() {
        handler.get_leave_decrement(game_id: game.id!) { response in
            if response.success == true {
                if response.decrement! == 0 {
                    self.decrementLabel.isHidden = true
                    self.arrowView.isHidden = true
                    self.mainTitle.text = "Sei sicuro di voler annullare la partita?"
                } else {
                    self.decrementLabel.text = "\(response.decrement!)"
                }
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
