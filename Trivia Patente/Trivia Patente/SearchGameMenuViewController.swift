//
//  SearchGameMenuViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchGameMenuViewController: TPNormalViewController {
    @IBOutlet var searchButton : UIButton!
    @IBOutlet var randomButton : UIButton!
    @IBOutlet var tournamentButton : UIButton!
    let handler = HTTPGame()
    
    var destinationGame : Game?
    
    override func needsMenu() -> Bool {
        return false
    }
    
    var recentInvitesView : TPExpandableView! {
        didSet {
            recentInvitesView.title = "Inviti a giocare"
            recentInvitesView.cellNibName = "InviteTableViewCell"
            recentInvitesView.footerText = "Nessun altro invito a giocare 😫"
            recentInvitesView.emptyFooterText = "Nessun invito a giocare 😫"
            recentInvitesView.emptyTitleText = "Nessun invito a giocare"
            recentInvitesView.rowHeight = 60
            recentInvitesView.separatorColor = Colors.primary
            recentInvitesView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            recentInvitesView.selectedCellHandler = {   item in
                guard self != nil else { return }
                let invite = item as! Invite
                self.destinationGame = Game(id: invite.gameId)
                self.destinationGame!.opponent = invite.sender
                self.goToWaitPage()
            }
        }
    }
    
    @IBAction func goToWaitPage() {
        self.performSegue(withIdentifier: "wait_opponent_segue", sender: self)
    }
    var invites : [Invite]! {
        didSet {
            self.recentInvitesView.items = invites
        }
    }
    func load() {
        let loadingView = MBProgressHUD.clearAndShow(to: self.view, animated: true)
        handler.invites { response in
            loadingView.hide(animated: true)
            if response.success == true {
                self.invites = response.invites
            } else {
                //TODO: error handler
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.mediumRounded()
        randomButton.mediumRounded()
        tournamentButton.mediumRounded()
        // ATTENTION: siccome sono stati tolti gli inviti si possono togliere queste due cose
//        self.load()
//        self.listen()
        
        self.setDefaultBackgroundGradient()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "recent_view" {
                self.recentInvitesView = segue.destination as! TPExpandableView
            } else if identifier == "wait_opponent_segue" {
                let waitController = segue.destination as! WaitOpponentViewController
                if let game = destinationGame {
                    waitController.game = game
                } else { //random invite
                    waitController.fromInvite = true
                }
            } else if identifier == "user_list_segue" {
                (segue.destination as! UserListViewController).listType = .searchOpponent
            }
        }
    }

}
