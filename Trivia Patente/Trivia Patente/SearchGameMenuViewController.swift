//
//  SearchGameMenuViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 21/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class SearchGameMenuViewController: UIViewController {
    @IBOutlet var searchButton : UIButton!
    @IBOutlet var randomButton : UIButton!
    
    var recentView : TPRecentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.mediumRounded()
        randomButton.mediumRounded()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "recent_view" {
                self.recentView = segue.destination as! TPRecentView
            }
        }
    }

}
