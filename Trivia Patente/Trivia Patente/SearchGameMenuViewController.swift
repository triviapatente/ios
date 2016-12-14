//
//  SearchGameMenuViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchGameMenuViewController: UIViewController {
    @IBOutlet var searchButton : UIButton!
    @IBOutlet var randomButton : UIButton!
    let handler = HTTPGame()
    let socketHandler = SocketGame()
    
    var destinationGame : Game?
    
    var recentInvitesView : TPExpandableView! {
        didSet {
            recentInvitesView.title = "Inviti a giocare"
            recentInvitesView.cellNibName = "InviteTableViewCell"
            recentInvitesView.footerText = "Nessun altro invito a giocare 😅"
            recentInvitesView.emptyFooterText = "Nessun invito a giocare 😅"
            recentInvitesView.rowHeight = 60
            recentInvitesView.separatorColor = Colors.primary
            recentInvitesView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            recentInvitesView.selectedCellHandler = { item in
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
    func listen() {
        socketHandler.listen_invite_created { response in
            if response?.success == true {
                let invite = response!.invite!
                invite.sender = response!.user
                self.recentInvitesView.add(item: invite)
            }
        }
    }
    func load() {
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
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
        self.load()
        self.listen()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "recent_view" {
                self.recentInvitesView = segue.destination as! TPExpandableView
            } else if identifier == "wait_opponent_segue" {
                let waitController = segue.destination as! WaitOpponentViewController
                if let game = destinationGame {
                    waitController.game = self.destinationGame
                } else { //random invite
                    waitController.fromInvite = true
                }
            }
        }
    }

}
