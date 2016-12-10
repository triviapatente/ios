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
    
    func identifier(for button : UIButton) -> String? {
        switch button {
            case chatButton: return "chat"
            
            case leaveButton: return "leave_game"
            
            case detailButton: return "round_details"
            default: return nil
        }
    }
    @IBAction func goto(sender : UIButton) {
        if let identifier = identifier(for: sender) {
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
                break
            case self.identifier(for: chatButton)!:
                (segue.destination as! ChatViewController).game = game
                break
            default:
                break
        }
    }

}
