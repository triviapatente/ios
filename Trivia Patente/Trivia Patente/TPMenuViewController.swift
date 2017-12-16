//
//  UIMenuViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 03/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPMenuViewController: BaseViewController, UIGestureRecognizerDelegate {

    let options = [MenuAction.profile, MenuAction.settings, MenuAction.credits, MenuAction.logout]
    var callback : ((MenuAction) -> Void)!
    
    @IBOutlet var optionsTableView: UITableView!
    
    @IBAction func dismissView(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.optionsTableView)
        let animated = self.needsAnimation(point: location)
        self.dismiss(animated: animated, completion: nil)
    }
    func needsAnimation(point : CGPoint) -> Bool {
        return !self.optionsTableView.point(inside: point, with: nil)
    }
    var navController : TPNavigationController!
    var barHeight : CGFloat {
        return self.navController.navigationBar.frame.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.optionsTableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.optionsTableView.frame.origin.y = self.barHeight + self.topLayoutGuide.length
    }
    
    

}

extension TPMenuViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / CGFloat(options.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "options_cell")!
        cell.textLabel?.text = options[indexPath.row].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let action = options[indexPath.row]
        callback(action)
    }
}
