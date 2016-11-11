//
//  StatsViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class StatsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "StatsTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "stats_cell")
        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = Shared.categories {
            return categories.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stats_cell") as! StatsTableViewCell
        cell.category = Shared.categories![indexPath.row]
        return cell
    }

}
