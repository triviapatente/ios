//
//  MainViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD
class MainViewController: UIViewController {
    
    var loadingView : MBProgressHUD!
    
    var playButton : TPMainButton!
    var rankButton : TPMainButton!
    var statsButton : TPMainButton!
    var shopButton : TPMainButton!
    
    var buttonClickListener = { (button : TPMainButton) in
        print("ciao")
    }
    let socketAuth = SocketAuth()
    override func viewDidLoad() {
        super.viewDidLoad()
        connectToSocket()
        self.playButton.initValues(imageName: "car", title: "Gioca", color: Colors.playColor, clickListener: buttonClickListener)
        self.rankButton.initValues(imageName: "trophy", title: "Classifica", color: Colors.rankColor, clickListener: buttonClickListener)
        self.statsButton.initValues(imageName: "chart-line", title: "Statistiche", color: Colors.statsColor, clickListener: buttonClickListener)
        self.shopButton.initValues(imageName: "heart", title: "Negozio", color: Colors.shopColor, clickListener: buttonClickListener)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.set(backgroundGradientColors: [Colors.primary.cgColor, Colors.secondary.cgColor])

    }
    func connectToSocket() {
        loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingView.mode = .indeterminate
        SessionManager.authenticateSocket { (response : TPConnectResponse?) in
            self.loadingView.hide(animated: true)
            //check if login was forbidden
            if response?.statusCode == 401 {
                SessionManager.drop()
                self.goToFirstAccess()
            } else {
                self.setHints(candidateResponse: response)
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
            return "\(category.hint!): \(category.progress!)%"
        }
    }
    func getShopHint(response : TPConnectResponse) -> String? {
        return nil
    }
    func goToFirstAccess() {
        let controller = UIViewController.root()
        self.present(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let identifier = segue.identifier {
            switch identifier {
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
                default: break
                
            }
        }
    }

}
