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
        SessionManager.authenticateSocket { (response : TPResponse?) in
            self.loadingView.hide(animated: true)
            if response?.success != true {
                SessionManager.drop()
                self.goToFirstAccess()
            } else {
                //TODO: remove and add proper values from server
                self.playButton.display(hint: "3 inviti a giocare")
            }
        }
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
