//
//  TPSectionBar.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 08/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPSectionBar: UIViewController {
    @IBOutlet var tableView : UITableView!
    
    var questionMap : [String : [QuizDetail]]! {
        didSet {
            self.tableView.reloadData()
        }
    }
    var game : Game! {
        didSet {
            self.tableView.reloadData()
        }
    }
    var currentPage : Int! {
        didSet {
            let indexPath = IndexPath(row: currentPage, section: 0)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
    }
    var delegate : TPSectionBarDelegate!
    
    var titles : [String] {
        guard questionMap != nil && game != nil else {
            return []
        }
        var array = questionMap.keys.sorted()
        if game.isEnded() {
            array.append("🏆")
        }
        return array
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TPSectionBarTableViewCell", bundle: .main)
        self.tableView.register(nib, forCellReuseIdentifier: "item_cell")
    }
}
extension TPSectionBar : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let count = self.tableView(tableView, numberOfRowsInSection: section)
        let height = self.tableView(tableView, heightForRowAt: IndexPath())
        return (self.tableView.frame.size.height - height * CGFloat(count)) / 2
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection: section)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selectPage(index: indexPath.row)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item_cell") as! TPSectionBarTableViewCell
        cell.valueLabel.text = titles[indexPath.row]
        return cell
    }
}
