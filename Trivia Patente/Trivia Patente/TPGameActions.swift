//
//  TPQuizActions.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 30/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPGameActions: BaseViewController {
    @IBOutlet var chatButton : UIButton!
    @IBOutlet var leaveButton : UIButton!
    @IBOutlet var detailButton : UIButton!
    @IBOutlet var timerButton : UIButton!
    @IBOutlet weak var timerImageView: UIImageView!
    @IBOutlet weak var timerContainer : UIView!
    var game : Game!
    var gameCancelled : Bool = false
    var sender : BasePlayViewController!
    
    var timerActionPressed : (() -> Void)? {
        didSet {
            self.timerContainer.isHidden = false
        }
    }
    
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
    @IBAction func timerAction() {
        if let cb = self.timerActionPressed {
            cb()
        }
        self.timerImageView.swing()
    }
    func setTimerActionState(active: Bool) {
        self.timerImageView.image = active ? UIImage(named: "action_bell_rang") : UIImage(named: "action_bell")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatButton.circleRounded()
        chatButton.darkerBorder(of: 0.10, width: 5)
        leaveButton.circleRounded()
        leaveButton.darkerBorder(of: 0.10, width: 5)
        detailButton.circleRounded()
        detailButton.darkerBorder(of: 0.10, width: 5)
        timerButton.circleRounded()
        timerButton.darkerBorder(of: 0.10, width: 5)
    }
    
    func leaveButttonEnabled(enabled: Bool) {
        leaveButton.isEnabled = enabled
    }
    
    func timerButttonEnabled(enabled: Bool) {
        timerButton.isEnabled = enabled
        timerImageView.alpha = enabled ? 1.0 : 0.8
    }
    
    func buttonShake(button : UIButton) {
        
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
