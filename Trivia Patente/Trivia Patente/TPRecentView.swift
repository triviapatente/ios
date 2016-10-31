//
//  TPRecentView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPRecentView: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var headerView : UINavigationBar!
    @IBOutlet var tableView : UITableView!
    
    var items : [Game] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "RecentGameTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "recent_cell")
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let mainView = self.view.superview?.superview {
            mainView.bringSubview(toFront: self.view.superview!)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func gestureRecognizerShouldBegin(_ sender: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = sender as? UIPanGestureRecognizer else { return true }
        
        // Ensure it's a vertical drag
        let velocity = gestureRecognizer.velocity(in: self.view)
        print(velocity)
        return abs(velocity.y) > 40
    }
    
    @IBAction func triggerFullScreen(sender : UIPanGestureRecognizer) {

        if let mainView = self.view.superview?.superview {
            let frame = self.view.convert(self.view.frame, to: mainView)
            UIView.animate(withDuration: 0.4) {
                //TODO: expand the view to full screen
                self.view.frame.origin.y = self.view.frame.origin.y - frame.origin.y
                self.view.frame.size.height = self.view.frame.size.height + frame.origin.y
            }
        }
    }
}

extension TPRecentView : UITableViewDataSource, UITableViewDelegate {
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recent_cell") as! RecentGameTableViewCell
        cell.game = items[indexPath.row]
        return cell
    }
}
