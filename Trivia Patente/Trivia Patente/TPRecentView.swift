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
    @IBOutlet var counterLabel : UILabel!
    @IBOutlet var tableView : UITableView!

    var items : [Base] = [] {
        didSet {
            dataLoaded = true
            adaptToItems()
        }
    }
    var cellNibName : String?
    var footerText : String = ""

    var dataLoaded = false
    var containerView : UIView {
        return self.view.superview!
    }
    var isHidden : Bool = false {
        didSet {
            self.containerView.isHidden = isHidden
        }
    }
    var tableHeight : CGFloat {
        return CGFloat(items.count) * self.tableView.rowHeight
    }
    var maxTableHeight : CGFloat {
        return 3 * self.tableView.rowHeight
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
    var footerView : UIView {
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80)
        let label = UILabel(frame: frame)
        label.text = footerText
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.isHidden = true
        label.numberOfLines = 2
        return label
    }
    var rowHeight : CGFloat?
    var separatorColor : UIColor?
    var separatorStyle : UITableViewCellSeparatorStyle?
    var separatorInset : UIEdgeInsets?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = cellNibName {
            let nib = UINib(nibName: name, bundle: Bundle.main)
            self.tableView.register(nib, forCellReuseIdentifier: "recent_cell")
        }
        if let inset = separatorInset {
            self.tableView.separatorInset = inset
        }
        if let style = separatorStyle {
            self.tableView.separatorStyle = style
        }
        if let color = separatorColor {
            self.tableView.separatorColor = color
        }
        if let height = rowHeight {
            self.tableView.rowHeight = height
        }
        headerView.topItem?.title = title
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainView.bringSubview(toFront: self.containerView)

        //enforce only the first initialization of the view position
        if dataLoaded == false {
            adaptToItems()
        }
    }
    
    func adaptToItems(reload : Bool = true) {
        self.view.frame.size.height = self.headerHeight + self.tableHeight
        minimize(origin: false)
        self.tableView.tableFooterView?.isHidden = false
        let candidate_y = self.containerSize.height - viewSize.height
        let maximum_y_value = self.containerSize.height - (self.headerHeight + self.maxTableHeight)
        if items.count < 3 && candidate_y > 0 {
            self.view.frame.origin.y = candidate_y
        } else if maximum_y_value > 0 {
            self.view.frame.origin.y = maximum_y_value
        }
        if reload {
            self.tableView.reloadData()
        }
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
                self.expand(up_thresold)
            } else {
                self.minimize()
            }
        }) { finish in
            self.mainView.bringSubview(toFront: self.containerView)
            self.view.addGestureRecognizer(sender)

        }
    }
    func expand(_ thresold : CGFloat) {
        self.tableView.isScrollEnabled = true
        self.containerView.frame.origin.y = thresold
        self.view.frame.size.height = self.mainSize.height
    }
    func minimize(origin : Bool = true) {
        self.tableView.isScrollEnabled = false
        if origin == true {
            self.containerView.frame.origin.y = self.mainSize.height - self.containerSize.height
        }
    }
}
extension TPRecentView : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ sender: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = sender as? UIPanGestureRecognizer else { return true }
        guard items.count > 0 else { return false }
        let velocity = gestureRecognizer.velocity(in: self.view)
        return abs(velocity.y) > 40
    }
}

extension TPRecentView : UITableViewDataSource, UITableViewDelegate {
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //se sono arrivato all'inizio, faccio il minimize
        if scrollView.contentOffset.y < -20 {
            UIView.animate(withDuration: 0.4, animations: {
                self.minimize()
            })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        counterLabel.text = items.isEmpty ? "" : "\(items.count)"
        return items.count
    }
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recent_cell") as! TPRecentTableViewCell
        cell.delegate = self
        cell.item = items[indexPath.row]
        return cell
    }
}
extension TPRecentView : TPRecentTableViewCellDelegate {
    
    func removeCell(for item: Base) {
        let index = self.items.index { candidate in
            return item == candidate
        }
        guard index != nil else {
            return
        }
        self.items.remove(at: index!)
        
    }
}
