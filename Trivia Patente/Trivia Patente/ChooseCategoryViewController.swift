//
//  ChooseCategoryViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class ChooseCategoryViewController: UIViewController {

    var gameHeader : TPGameHeader!
    var tableView : UITableView!
    
    var game : Game!
    
    var round : Round! {
        didSet {
            self.gameHeader.round = round
        }
    }
    var categories : [Category]! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProposedCategoryTableViewCell", bundle: .main)
        self.tableView.register(nib, forCellReuseIdentifier: "category_cell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "header_view" {
            gameHeader = segue.destination as! TPGameHeader
        }
    }

}

extension ChooseCategoryViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category_cell") as! ProposedCategoryTableViewCell
        cell.category = self.categories[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categories[indexPath.row]
        //TODO: choose category
    }
}
