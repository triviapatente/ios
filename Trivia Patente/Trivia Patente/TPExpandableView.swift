//
//  TPRecentView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPExpandableView: UIViewController {
    @IBOutlet var headerView : UINavigationBar!
    @IBOutlet var counterLabel : UILabel!
    @IBOutlet var tableView : UITableView!

    var items : [Base] = [] {
        didSet {
            if !dataLoaded {
                adaptToItems()
            }
            dataLoaded = true
            self.tableView.tableFooterView = footerView
        }
    }
    func add(item : Base) {
        self.items.append(item)
        self.tableView.reloadData()
    }
    func remove(item : Base) {
        if let index = self.items.index(of: item) {
            self.items.remove(at: index)
        }
    }
    var selectedCellHandler : ((Base) -> Void)?
    var cellNibName : String?
    var footerText : String = ""
    var emptyFooterText : String!
    
    var footer : String {
        if items.isEmpty && emptyFooterText != nil {
            return emptyFooterText
        }
        return footerText
    }

    var dataLoaded = false
    var containerView : UIView {
        return self.view.superview!
    }
    var expanded : Bool = false
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
    //number of items dependent: settare a items già settati
    var footerFrame : CGRect {
        let height = self.mainSize.height - self.tableHeight - self.headerHeight
        if height <= 0 {
            return .zero
        }
        let rect = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: height)
        return rect
    }
    var previousContainerHeight : CGFloat!
    
    //number of items dependent: settare a items già settati
    var footerView : UIView {
        let label = UILabel(frame: footerFrame)
        label.text = footer
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }
    //handler che da fuori permette di stabilire l'altezza di espansione di una cella (dinamico)
    var cellExpandHandler : ((Int) -> CGFloat)?
    
    var rowHeight : CGFloat?
    var separatorColor : UIColor?
    var needsSeparator : Bool = true
    var separatorInset : UIEdgeInsets = .zero
    
    var separatorView : UIView {
        let height = CGFloat(0.5)
        let width = self.view.frame.size.width - (self.separatorInset.left + self.separatorInset.right)
        let x = self.separatorInset.left
        let frame = CGRect(x: x, y: self.tableView.rowHeight - height, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = separatorColor ?? .white
        return view
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = cellNibName {
            let nib = UINib(nibName: name, bundle: Bundle.main)
            self.tableView.register(nib, forCellReuseIdentifier: "recent_cell")
        }
        self.tableView.separatorStyle = .none
        if let height = rowHeight {
            self.tableView.rowHeight = height
        }
        headerView.topItem?.title = title
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainView.bringSubview(toFront: self.containerView)
        if previousContainerHeight == nil {
            previousContainerHeight = self.containerSize.height
        }
        //enforce only the first initialization of the view position
        if dataLoaded == false {
            adaptToItems()
        }
    }
    
    func adaptToItems(reload : Bool = true) {
        self.view.frame.size.height = self.headerHeight + self.tableHeight
        minimize(origin: false)
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
        
        let canGoUp = up_pan && !self.expanded
        let canGoDown = !up_pan && self.expanded
        guard canGoUp || canGoDown else {
            return
        }
        self.view.removeGestureRecognizer(sender)
        let up_thresold = -self.view.frame.origin.y

        UIView.animate(withDuration: 0.4, animations: {
            if up_pan == true {
                self.expand(up_thresold)
            } else {
                self.minimize()
            }
        }) { finish in
            self.expanded = up_pan
            self.mainView.bringSubview(toFront: self.containerView)
            self.view.addGestureRecognizer(sender)
        }
    }
    func expand(_ thresold : CGFloat) {
        self.tableView.isScrollEnabled = true
        self.containerView.frame.origin.y = thresold
        self.view.frame.size.height = self.mainSize.height
        self.containerView.frame.size.height = self.view.frame.size.height
    }
    func minimize(origin : Bool = true) {
        self.tableView.isScrollEnabled = false
        if origin == true {
            self.containerView.frame.origin.y = self.mainSize.height - self.previousContainerHeight
        }
    }
}
extension TPExpandableView : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ sender: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = sender as? UIPanGestureRecognizer else { return true }
        let velocity = gestureRecognizer.velocity(in: self.view)
        //se è un tap verso l'alto (expand) non farlo se ha 0 elementi
        if velocity.y < 0 {
            guard items.count > 0 else { return false }
        }
        return abs(velocity.y) > 40
    }
}

extension TPExpandableView : UITableViewDataSource, UITableViewDelegate {
    
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedPath = tableView.indexPathForSelectedRow {
            if let handler = cellExpandHandler {
                if indexPath.row == selectedPath.row {
                    return handler(indexPath.row)
                }
            }
        }
        if let height = rowHeight {
            return height
        } else {
            return 80
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = cellExpandHandler {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recent_cell") as! TPExpandableTableViewCell
        cell.delegate = self
        cell.item = items[indexPath.row]
        if indexPath.row != self.items.count - 1 {
            cell.addSubview(separatorView)
        }
        return cell
    }
}
extension TPExpandableView : TPExpandableTableViewCellDelegate {
    func selectCell(for item: Base) {
        if let handler = selectedCellHandler {
            handler(item)
        }
    }

    
    func removeCell(for item: Base) {
        let index = self.items.index { candidate in
            return item == candidate
        }
        guard index != nil else {
            return
        }
        self.items.remove(at: index!)
        let path = IndexPath(row: index!, section: 0)
        self.tableView.deleteRows(at: [path], with: .fade)
        if !expanded {
            adaptToItems(reload: false)
        }
        
    }
}
