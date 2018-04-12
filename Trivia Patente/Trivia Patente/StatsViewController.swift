//
//  StatsViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class StatsViewController: TPNormalTableViewController {

    let socketAuth = SocketAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "StatsTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "stats_cell")
        // Do any additional setup after loading the view.
        let gradientLayer = self.gradientLayer()
        gradientLayer.frame = self.tableView.bounds
        let backgroundView = UIView(frame: self.tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.tableView.backgroundView = backgroundView
        
        self.tableView.refreshControl = UIRefreshControl(frame: CGRect.zero)
        self.tableView.refreshControl!.tintColor = UIColor.white
        self.tableView.refreshControl!.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        self.loadData(loadAnimation: Shared.categories == nil)
    }
    
    func refreshData() {
        self.loadData(loadAnimation: false)
    }
    
    func loadData(loadAnimation: Bool) {
        if loadAnimation {
            MBProgressHUD.hide(for: self.view, animated: true)
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        self.socketAuth.global_infos {   (response : TPConnectResponse?) in
            guard self != nil else { return }
            if let success = response?.success {
                if success {
//                    MainViewController.trainings_stats = response!.traini ng_stats
                    self.tableView.reloadData()
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.refreshControl?.endRefreshing()
        }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let categories = Shared.categories {
            if categories[indexPath.row].progress > 0 {
                self.performSegue(withIdentifier: "single_view_segue", sender: self)
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "single_view_segue" {
            let destination = segue.destination as! SingleStatViewController
            if let path = self.tableView.indexPathForSelectedRow {
                destination.category = Shared.categories![path.row]
            }
        }
    }

}
