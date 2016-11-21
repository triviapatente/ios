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
    
    var recentInvitesView : TPRecentView! {
        didSet {
            recentInvitesView.title = "Inviti a giocare"
            recentInvitesView.cellNibName = "InviteTableViewCell"
            recentInvitesView.footerText = "Nessun altro invito a giocare 😅"
            recentInvitesView.rowHeight = 60
            recentInvitesView.separatorColor = Colors.primary
            recentInvitesView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func loadInvites() {
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        handler.invites { response in
            loadingView.hide(animated: true)
            if response.success == true {
                self.recentInvitesView.items = response.invites
            } else {
                //TODO: error handler
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.mediumRounded()
        randomButton.mediumRounded()
        loadInvites()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "recent_view" {
                self.recentInvitesView = segue.destination as! TPRecentView
            }
        }
    }

}
