//
//  LeaveGameViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class LeaveGameViewController: BaseViewController {
    @IBOutlet var containerView : UIView!
    @IBOutlet var decrementLabel : UILabel!
    @IBOutlet var dismissButton : UIButton!
    @IBOutlet var leaveButton : UIButton!
    @IBOutlet weak var mainTitle: UILabel!
    
    var game : Game!
    
    let handler = HTTPGame()
    
    var sender : TPGameActions!
    
    @IBAction func buttonTapped(button : UIButton) {
        if button == dismissButton {
            self.fade()
        } else if button == leaveButton {
            // TODO: remove specific code from here, use delegate
            if game == nil {
                // training
                self.fade()
                sender.sender.exitPlaying()
            } else {
                handler.leave_game(game_id: game.id!) {   response in
                    guard self != nil else { return }
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
    }
    func getDecrement() {
        handler.get_leave_decrement(game_id: game.id!) {   response in
            guard self != nil else { return }
            if response.success == true {
                if response.decrement! == 0 {
                    self.mainTitle.text = "Sei sicuro di voler annullare la partita?"
                } else {
                    self.mainTitle.text = "Sei sicuro di volerti arrendere?"
                    self.decrementLabel.isHidden = false
                    self.decrementLabel.text = "\(response.decrement!) \(abs(response.decrement) == 1 ? "punto" : "punti")"
                }
            }
        }
    }
    
    func handleExitTraining() {
        self.mainTitle.text = "Tutti i progressi del questionario verranno persi. Sei sicuro di voler uscire?"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissButton.mediumRounded()
        self.leaveButton.mediumRounded()
        self.containerView.mediumRounded()

        if game == nil {
            // training
            handleExitTraining()
        } else {
            self.getDecrement()
        }
    }
    

}
