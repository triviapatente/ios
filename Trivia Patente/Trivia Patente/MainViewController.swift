//
//  MainViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD
class MainViewController: TPNormalViewController {
    
    var loadingView : MBProgressHUD!
    
    var playButton : TPMainButton!
    var rankButton : TPMainButton!
    var statsButton : TPMainButton!
    var shopButton : TPMainButton!
    var selectedGame : Game!
    @IBOutlet var recentGamesViewContainer : UIView!
    var recentGamesView : TPExpandableView! {
        didSet {
            recentGamesView.cellNibName = "RecentGameTableViewCell"
            recentGamesView.footerText = "Non ci sono altre partite.. \nIniziane un’altra 😉"
            recentGamesView.emptyTitleText = "Nessuna partita recente"
            recentGamesView.title = "Partite recenti"
            recentGamesView.separatorColor = Colors.primary
            recentGamesView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            recentGamesView.selectedCellHandler = { item in
                self.selectedGame = item as! Game
                self.performSegue(withIdentifier: "start_game_segue", sender: self)
            }
        }
    }
    static var pushGame : Game?
    
    var buttonClickListener : ((TPMainButton) -> Void)!
    let socketAuth = SocketAuth()
    let socketGame = SocketGame()
    let httpGame = HTTPGame()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buttonClickListener = { button in
            if let identifier = self.getSegueIdentifier(for: button) {
                self.performSegue(withIdentifier: identifier, sender: self)
            }
        }
    }
    func resetBackgroundGradientLocations() {
        self.setBackgroundGradientBounds(start: 0, end: Float(1 - (self.recentGamesViewContainer.frame.origin.y / self.view.frame.height)))
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.resetBackgroundGradientLocations()
    }
    func getSegueIdentifier(for button: TPMainButton) -> String? {
        switch(button) {
            case self.playButton: return "play_segue"
            case self.rankButton: return "rank_segue"
            case self.statsButton: return "alpha_segue"
            case self.shopButton: return "alpha_segue"

            default: return nil
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.playButton.initValues(imageName: "car", title: "Nuova partita", color: Colors.playColor, clickListener: buttonClickListener)
        self.rankButton.initValues(imageName: "trophy", title: "Classifica", color: Colors.rankColor, clickListener: buttonClickListener)
        self.statsButton.initValues(imageName: "chart-line", title: "Statistiche", color: Colors.statsColor, clickListener: buttonClickListener)
        self.shopButton.initValues(imageName: "heart", title: "Negozio", color: Colors.shopColor, clickListener: buttonClickListener)
        
        self.setDefaultBackgroundGradient()
        self.resetBackgroundGradientLocations()
        // set Stats and Shop as coming soon
        
        self.recentGamesView.traslate(up: false, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statsButton.setComingSoon()
        self.shopButton.setComingSoon()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        (self.navigationController! as! TPNavigationController).configureBar()
        self.recentGamesView.view.isUserInteractionEnabled = true
        MBProgressHUD.hide(for: self.view, animated: false)
        RecentGameHandler.start(delegate: self.recentGamesView, callback: { () in
            self.socketGame.listen_recent_games(handler: { (event) in
                self.recentGamesView.retrieveRecentGames()
            })
        })

        connectToSocket(showLoader: SocketManager.getStatus() != .connected)
        SocketManager.leave(type: "game")
    }
    func socketStartLoading() {
        MBProgressHUD.hide(for: self.view, animated: false)
        loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingView.mode = .indeterminate
        loadingView.center = CGPoint(x: loadingView.center.x, y: TPExpandableView.DEAFULT_CONTAINER_TOP_SPACE / 2)
        self.recentGamesView.view.isUserInteractionEnabled = false
    }
    func socketStopLoading() {
        self.loadingView.hide(animated: true)
        self.recentGamesView.view.isUserInteractionEnabled = true
    }
    var firstConnection = true
    func registerFirebaseSession() {
        if let _ = SessionManager.currentUser {
            if firstConnection {
                FirebaseManager.register()
                self.firstConnection = false
            }
        }
    }
    func connectToSocket(showLoader: Bool = true) {
        if SocketManager.getStatus() != .connected {
            self.recentGamesView.traslate(up: false)
        }
        if showLoader {
            self.socketStartLoading()
        }
        SocketManager.connect(handler: {
            if let _ = MainViewController.pushGame {
                self.performSegue(withIdentifier: "pushGameSegue", sender: self)
                return
            }
            self.recentGamesView.retrieveRecentGames()
            if showLoader { self.socketStopLoading() }
            self.socketAuth.global_infos { (response : TPConnectResponse?) in
                self.registerFirebaseSession()
                //check if login was forbidden
                if response?.statusCode == 401 {
                    SessionManager.drop()
                    UIViewController.goToFirstAccess(from: self)
                } else {
                    self.setHints(candidateResponse: response)
                    let navController = self.navigationController as! TPNavigationController
                    navController.handleLegislationUpdate(serverDate: response!.privacyPolicyLastUpdate, type: .privacyUpdate)
                    navController.handleLegislationUpdate(serverDate:
                        response!.termsLastUpdate, type: .termsUpdate)
                }
            }
            
            
        }) {
            MainViewController.handleSocketDisconnection()
        }
    }
    
    class func handleSocketDisconnection()
    {
        let noConnConntroller = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "no_connection_controller")
        noConnConntroller.modalTransitionStyle = .crossDissolve
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if let _ = topController as? NoConnectionViewController {} else {
                topController.present(noConnConntroller, animated: true, completion: nil)
            }
        }
    }
    func setHints(candidateResponse : TPConnectResponse?) {
        if let response = candidateResponse {
            if let playHint = getPlayHint(response: response) {
                self.playButton.display(hint: playHint)
            }
            
            let rankHints = getRankHints(response: response)
            self.rankButton.display(hints: rankHints)
            let statsHints = getStatsHints(response: response)
            self.statsButton.display(hints: statsHints)
            
            if let shopHint = getShopHint(response: response) {
                self.shopButton.display(hint: shopHint)
            }
        }
    }
    func getPlayHint(response : TPConnectResponse) -> String? {
        if let count = response.invitesCount {
            if count > 1  {
                return "\(count) inviti a giocare"
            } else if count == 1 {
                return "\(count) invito a giocare"
            }
        
        }
        return nil
    }
    func getRankHints(response : TPConnectResponse) -> [String] {
        var output : [String] = []
        if let global = response.globalRankPosition {
            output.append("Globale: \(global)")
        }
        if let friends = response.friendsRankPosition {
            output.append("Amici: \(friends)")
        }
        return output
    }
    func getStatsHints(response : TPConnectResponse) -> [String] {
        return response.stats.map { (category : Category) -> String in
            return "\(category.hint!): \(category.progress)%"
        }
    }
    func getShopHint(response : TPConnectResponse) -> String? {
        return nil
    }
    
    class func handleReconnectionJoinRoom() {
        // se siamo su una parita di gioco allora assicurati di rietntrare nelle room
        if let controller = UIApplication.topViewController() as? TPGameViewController {
            controller.join_room()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let identifier = segue.identifier {
            self.navigationController!.popToRootViewController(animated: true)
            switch identifier {
            case "pushGameSegue":
                
                    (destination as! WaitOpponentViewController).game = MainViewController.pushGame
                    MainViewController.pushGame = nil
                    
                    break
                case "play":
                    self.playButton = destination as! TPMainButton
                    break
                case "rank":
                    self.rankButton = destination as! TPMainButton
                    break
                case "stats":
                    self.statsButton = destination as! TPMainButton
                    break
                case "shop":
                    self.shopButton = destination as! TPMainButton
                    break
                case "recent_view":
                    self.recentGamesView = destination as! TPExpandableView
                    break
                case "chat_segue":
                    let destination = destination as! ChatViewController
                    destination.game = selectedGame
                    break
                case "start_game_segue":
                    let destination = destination as! WaitOpponentViewController
                    destination.game = selectedGame
                    break
                default: break
                
            }
        }
    }

}
