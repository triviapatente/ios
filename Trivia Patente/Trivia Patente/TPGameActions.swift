//
//  TPQuizActions.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 30/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPGameActions: UIViewController {
    @IBOutlet var chatButton : UIButton!
    @IBOutlet var leaveButton : UIButton!
    @IBOutlet var detailButton : UIButton!
    var game : Game!
    var gameCancelled : Bool = false
    
    func identifier(for button : UIButton) -> String? {
        switch button {
            case chatButton: return "chat"
            
            case leaveButton: return "leave_game"
            
            case detailButton: return "round_details"
            default: return nil
        }
    }
    var parentView : UIView {
        return self.view.superview!
    }
    @IBAction func goto(sender : UIButton) {
        if let identifier = identifier(for: sender) {
            if sender == leaveButton {
                self.parentView.fade()
            }
            self.performSegue(withIdentifier: identifier, sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatButton.circleRounded()
        chatButton.darkerBorder(of: 0.10, width: 5)
        leaveButton.circleRounded()
        leaveButton.darkerBorder(of: 0.10, width: 5)
        detailButton.circleRounded()
        detailButton.darkerBorder(of: 0.10, width: 5)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier!
        switch identifier {
            case self.identifier(for: detailButton)! :
                (segue.destination as! RoundDetailsViewController).game = game
                (segue.destination as! RoundDetailsViewController).gameCancelled = self.gameCancelled
                break
            case self.identifier(for: chatButton)!:
                (segue.destination as! ChatViewController).game = game
                break
            
            case self.identifier(for: leaveButton)!:
                if let leaveController = segue.destination as? LeaveGameViewController {
                    leaveController.game = game
                    leaveController.sender = self
                }
                break
            default:
                break
        }
    }

}
