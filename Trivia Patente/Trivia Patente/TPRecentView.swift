//
//  TPRecentView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPRecentView: UIViewController {
    @IBOutlet var headerView : UINavigationBar!
    @IBOutlet var tableView : UITableView!

    var items : [Game] = [] {
        didSet {
            self.view.frame.size.height = headerHeight + tableHeight

            if items.count < 3 {
                self.view.frame.origin.y = self.containerSize.height - viewSize.height
            }

            self.tableView.reloadData()
        }
    }
    var containerView : UIView {
        return self.view.superview!
    }
    var tableHeight : CGFloat {
        return CGFloat(items.count) * self.tableView.rowHeight
    }
    var viewSize : CGSize {
        return self.view.frame.size
    }
    var containerSize : CGSize {
        return self.containerView.frame.size
    }
    var mainSize : CGSize {
        return mainView.frame.size
    }
    var mainView : UIView {
        return parent!.view
    }
    var headerHeight : CGFloat {
        return headerView.frame.size.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "RecentGameTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "recent_cell")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: fix bug.. the view is over the loading view
        mainView.bringSubview(toFront: self.view)
        mainView.bringSubview(toFront: self.containerView)
    }
    
    
    
    @IBAction func triggerFullScreen(sender : UIPanGestureRecognizer) {
        let up_pan = sender.velocity(in: self.view).y < 0
        
        let now_offset = self.containerView.frame.origin.y
        let up_thresold = -self.view.frame.origin.y
        guard (up_pan && now_offset > up_thresold) || (!up_pan && now_offset <= up_thresold) else {
            return
        }
        self.view.removeGestureRecognizer(sender)
        UIView.animate(withDuration: 0.4, animations: {
            if up_pan == true {
                self.containerView.frame.origin.y = up_thresold
                self.view.frame.size.height = self.mainSize.height
            } else {
                self.containerView.frame.origin.y = self.mainSize.height - self.containerSize.height
                self.view.frame.size.height = self.headerHeight + self.tableHeight

            }
        }) { finish in
            self.view.addGestureRecognizer(sender)

        }
    }
}
extension TPRecentView : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ sender: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = sender as? UIPanGestureRecognizer else { return true }
        
        let velocity = gestureRecognizer.velocity(in: self.view)
        return abs(velocity.y) > 40
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
