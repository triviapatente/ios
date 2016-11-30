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
    var round : Round!
    var opponent : User!
    var category : Category?
    func configureView() {
        self.opponentImageView.circleRounded()
        self.opponentImageView.load(user: opponent)
        self.opponentImageView.rotatingBorder(color: Colors.green_default)
        headerView.round = round
        if let cat = self.category {
            headerView.category = cat
        } else {
            headerView.categoryNameView.text = "Attendi.."
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        (self.navigationController as! TPNavigationController).setUser(candidate: opponent)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "header_segue" {
                self.headerView = segue.destination as! TPGameHeader
            }
        }
    }
 

}
