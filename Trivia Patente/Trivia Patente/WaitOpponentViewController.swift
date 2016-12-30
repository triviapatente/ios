//
//  WaitOpponentViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 30/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class WaitOpponentViewController: TPGameViewController {
    @IBOutlet var waitLabel : UILabel!
    @IBOutlet var opponentImageView : UIImageView!
    
    var headerView : TPGameHeader!
    var gameActions : TPGameActions! {
        didSet {
            self.gameActions.game = self.game
        }
    }
    var game : Game! {
        didSet {
            if self.gameActions != nil {
                self.gameActions.game = self.game
            }
        }
    }
    var fromInvite : Bool = false
    var userToInvite : User?
    var response : TPInitRoundResponse! {
        didSet {
            if let game_round = response.round {
                headerView.round = game_round
            } else if let cat = self.response.category {
                headerView.category = cat
            } else {
                self.headerView.set(title: self.waitTitle())
            }
        }
    }
    func listenForInvite() {
        socketHandler.listen_invite_processed { response in
            if response?.success == true {
                if response!.accepted == true {
                    self.join_room()
                } else {
                    self.handleInviteRefused()
                }
            }
        }
    }
    func unlisten() {
        socketHandler.unlisten(events: "category_chosen", "round_ended", "user_joined", "user_left")
    }
    func listenInRoom() {
        self.listenForInvite()
        socketHandler.listen(event: "category_chosen") { response in
            self.init_round()

        }
        socketHandler.listen(event: "round_ended") { response in
            self.init_round()
        }
        
        socketHandler.listen(event: "user_joined") { response in
            self.join_room()
        }
        socketHandler.listen(event: "user_left") { response in
            self.join_room()
        }
       
    }
    func handleInviteRefused() {
        let alert = UIAlertController(title: "Invito rifiutato", message: "L'utente ha rifiutato il tuo invito a giocare!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Indietro", style: .cancel) { action in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    func configureView() {
        (self.navigationController as! TPNavigationController).setUser(candidate: game.opponent)
        self.opponentImageView.load(user: game.opponent)
        self.opponentImageView.circleRounded()
        self.headerView.set(title: self.waitTitle())
        if fromInvite == true {
            self.headerView.roundLabel.text = "Invito"
        } else {
            self.headerView.roundLabel.text = "Partita"
        }
    }
    let socketHandler = SocketGame()
    let httpHandler = HTTPGame()
    
    
    func waitTitle(for state: RoundWaiting? = nil) -> String {
        if let _ = state {
            return "Attendi.."
        } else {
            return "Caricamento.."
        }
    }
    func waitMessage(for state: RoundWaiting, opponent_online : Bool) -> String {
        guard opponent_online || state == .invite else {
            return "Il tuo avversario è offline. Attendi che si ricolleghi per giocare!"
        }
        switch(state) {
            case .game: return "Attendi che il tuo avversario finisca il turno!"
            case .category: return "Attendi che il tuo avversario scelga la categoria del turno!"
            case .invite: return "Attendi che l'utente accetti il tuo invito a giocare!"
        }
    }
    func color(for state : RoundWaiting, opponent_online : Bool) -> UIColor {
        guard opponent_online || state == .invite else {
            return .white
        }
        switch state {
            case .category: return Colors.yellow_default
            case .game: return Colors.green_default
            case .invite: return Colors.red_default
        }
    }
    func segue(for state : RoundWaiting) -> String? {
        switch state {
            case .category: return "choose_category"
            case .game: return "play_round"
            case .invite: return nil
        }
    }
    func processResponse(response : TPInitRoundResponse, followRedirects: Bool = true) {
        self.response = response
        if response.ended == true && followRedirects {
            self.redirect(identifier: "round_details")
        } else {
            guard let state = response.waiting else {
                return
            }
            if state == .invite {
                response.waiting_for = game.opponent
            }
            guard let user = response.waiting_for else {
                return
            }
            self.processGameState(state: state, user: user, opponent_online: response.opponent_online, followRedirects: followRedirects)
        }
    }
    func processGameState(state : RoundWaiting, user: User, opponent_online : Bool = false, followRedirects : Bool = true) {
        if user.isMe() && followRedirects {
            if let identifier = self.segue(for: state) {
                self.redirect(identifier: identifier)
            }
        } else {
            let color = self.color(for: state, opponent_online: opponent_online)
            self.opponentImageView.rotatingBorder(color: color)
            self.waitLabel.text = self.waitMessage(for: state, opponent_online: opponent_online)
            self.headerView.set(title: self.waitTitle(for: state))
        }
    }
    func join_room() {
        self.opponentImageView.rotatingBorder(color: .white)
        socketHandler.join(game_id: game.id!) { (joinResponse : TPResponse?) in
            if joinResponse?.success == true {
                self.init_round()
                self.listenInRoom()
            } else {
                //TODO: handle error
            }
        }
    }
    func init_round(followRedirects : Bool = true) {
        socketHandler.init_round(game_id: game.id!) { (response : TPInitRoundResponse?) in
            if response?.success == true {
                self.processResponse(response: response!, followRedirects: followRedirects)
            } else {
                //TODO: handle_error
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if fromInvite == true {
            self.createInvite()
        } else {
            self.join_room()
            self.configureView()
        }
    }
    func createInvite() {
        let handler = { (response : TPNewGameResponse) in
            if response.success == true {
                response.game.opponent = response.opponent
                self.game = response.game
                self.configureView()
                //TODO: change with processGameState for invite (in round_init response)
                self.processGameState(state: .invite, user: self.game.opponent, opponent_online: true)
                self.join_room()
                self.fromInvite = false
            } else {
                //TODO: error handler
            }
        }
        if let opponent = userToInvite {
            httpHandler.newGame(id: opponent.id!, handler: handler)
        } else {
            httpHandler.randomNewGame(handler: handler)
        }
    }
    func redirect(identifier : String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.unlisten()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //non deve essere chiamato al primo accesso alla view, ma solo quando si torna indietro da un viewcontroller
        if response != nil {
            self.listenInRoom()
            self.init_round(followRedirects: false)
        }
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
                    destination.game = game
                }
            } else if identifier == "choose_category" {
                if let destination = segue.destination as? ChooseCategoryViewController {
                    destination.opponent = game.opponent
                    destination.round = response.round
                    destination.game = game
                }
            } else if identifier == "round_details" {
                if let destination = segue.destination as? RoundDetailsViewController {
                    destination.game = game
                }
            } else if identifier == "game_actions" {
                self.gameActions = segue.destination as! TPGameActions
            }
        }
    }
 

}
