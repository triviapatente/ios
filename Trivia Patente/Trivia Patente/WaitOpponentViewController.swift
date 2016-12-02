//
//  WaitOpponentViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 30/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class WaitOpponentViewController: UIViewController {
    @IBOutlet var waitLabel : UILabel!
    @IBOutlet var opponentImageView : UIImageView!
    
    var headerView : TPGameHeader!
    var game : Game!
    var response : TPInitRoundResponse! {
        didSet {
            if let game_round = response.round {
                headerView.round = game_round
            } else if let cat = self.response.category {
                headerView.category = cat
            } else {
                headerView.categoryNameView.text = "Attendi.."
            }
        }
    }
    func configureView() {
        self.opponentImageView.load(user: game.opponent)
        self.opponentImageView.circleRounded()
        self.headerView.categoryNameView.text = self.waitTitle()
    }
    let handler = SocketGame()
    
    func waitTitle(for state: RoundWaiting? = nil) -> String {
        if let _ = state {
            return "Attendi.."
        } else {
            return "Caricamento.."
        }
    }
    func waitMessage(for state: RoundWaiting) -> String {
        switch(state) {
            case .game: return "Attendi che il tuo avversario finisca il turno!"
            case .category: return "Attendi che il tuo avversario scelga la categoria del turno!"
        }
    }
    func color(for state : RoundWaiting) -> UIColor {
        switch state {
            case .category: return Colors.yellow_default
            case .game: return Colors.green_default
        }
    }
    func segue(for state : RoundWaiting) -> String {
        switch state {
            case .category: return "choose_category"
            case .game: return "play_round"
        }
    }
    func processGameState(response : TPInitRoundResponse) {
        self.response = response
        if response.ended == true {
            self.redirect(identifier: "round_details_segue")
            //TODO: go to round details page
        } else {
            guard let user = response.waiting_for else {
                return
            }
            guard let state = response.waiting else {
                return
            }
            if user.isMe() {
                let identifier = self.segue(for: state)
                self.redirect(identifier: identifier)
            } else {
                let color = self.color(for: state)
                self.opponentImageView.rotatingBorder(color: color)
                self.waitLabel.text = self.waitMessage(for: state)
                self.headerView.categoryNameView.text = self.waitTitle(for: state)
            }
        }
    }
    func join_room() {
        self.opponentImageView.rotatingBorder(color: .white)
        handler.join(game_id: game.id!) { (joinResponse : TPResponse?) in
            if joinResponse?.success == true {
                self.init_round()
            } else {
                //TODO: handle error
            }
        }
    }
    func init_round() {
        handler.init_round(game_id: game.id!) { (response : TPInitRoundResponse?) in
            if response?.success == true {
                self.processGameState(response: response!)
            } else {
                //TODO: handle_error
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.navigationController as! TPNavigationController).setUser(candidate: game.opponent)
        self.configureView()
        self.join_room()
    }
    func redirect(identifier : String) {
        //TODO: rimuovere questo viewcontroller
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "header_segue" {
                self.headerView = segue.destination as! TPGameHeader
            } else if identifier == "play_round" {
                if let destination = segue.destination as? PlayRoundViewController {
                    destination.opponent = game.opponent
                    destination.round = response.round
                    destination.category = response.category
                }
            } else if identifier == "choose_category" {
                if let destination = segue.destination as? ChooseCategoryViewController {
                    destination.opponent = game.opponent
                    destination.round = response.round
                }
            } else if identifier == "round_details" {
                if let destination = segue.destination as? RoundDetailsViewController {
                    destination.game = game
                }
            }
        }
    }
 

}
