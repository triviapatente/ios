//
//  TPRecentView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPExpandableView: BaseViewController {
    static let DEAFULT_CONTAINER_TOP_SPACE = CGFloat(320)
    
    @IBOutlet weak var headerView : UINavigationBar!
//    @IBOutlet var counterLabel : UILabel!
    @IBOutlet var reloadBarButton : UIBarButtonItem!
    @IBOutlet weak var reloadingActivityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var scrollRecognizer : UIPanGestureRecognizer!

    var items : [Base] = [] {
        didSet {
            adaptToItems()
            dataLoaded = true
            self.tableView.tableFooterView = footerView
            self.headerView.topItem?.title = headerTitle
            self.reloadDidEnd()
        }
    }
    var selectedCellHandler : ((Base) -> Void)?
    var cellNibName : String?
    var footerText : String = ""
    var emptyFooterText : String!
    var emptyTitleText : String!
    
    var expandedTopConstraintCostant : CGFloat {
        let recentsHeight = (self.headerHeight + self.tableHeight)
        var recentsTop = self.containerView.superview!.frame.height - recentsHeight
        if #available(iOS 11.0, *) {
            recentsTop -= self.view.safeAreaInsets.bottom
        }
        
//        recentsTop = recentsTop > TPExpandableView.DEAFULT_CONTAINER_TOP_SPACE ? recentsTop : TPExpandableView.DEAFULT_CONTAINER_TOP_SPACE
//        let rh = self.tableView.rowHeight
//        let filledRows = ((self.containerView.superview!.frame.height - recentsTop - self.headerHeight) / rh)
//        let optimalHeight = (rh * filledRows.rounded(FloatingPointRoundingRule.down)) + self.headerHeight
//        recentsTop = self.containerView.superview!.frame.height - optimalHeight
        
        return recentsTop > TPExpandableView.DEAFULT_CONTAINER_TOP_SPACE ? recentsTop : TPExpandableView.DEAFULT_CONTAINER_TOP_SPACE
    }
    var tableViewLastScrollOffset = CGFloat(0)
    
    var headerTitle : String? {
        if items.isEmpty {
            return emptyTitleText
        }
        return self.title
    }
    
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
        return headerView.frame.size.height > 44.0 ? headerView.frame.size.height : 44.0
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
    
    @IBAction func retrieveRecentGames() {
        self.reloadWillStart()
        RecentGameHandler.refresh { response, games in
            if response.success == true {
                let sortFn = { (f: Game, s: Game) -> Bool in
                    return f.updatedAt! > s.updatedAt!
                }
                let my_turn_games = games!.filter({ (g: Game) -> Bool in
                    return g.my_turn && !g.ended
                }).sorted(by: sortFn)
                let your_turn_games = games!.filter({ (g: Game) -> Bool in
                    return !g.my_turn && !g.ended
                }).sorted(by: sortFn)
                let ended_games = games!.filter({ (g: Game) -> Bool in
                    return g.ended
                }).sorted(by: sortFn)
                
                self.items = my_turn_games + your_turn_games + ended_games
            }
        }
    }
    
    func reloadWillStart()
    {
        headerView.topItem?.rightBarButtonItem = nil
        self.reloadingActivityIndicator.startAnimating()
    }
    func reloadDidEnd()
    {
        headerView.topItem?.rightBarButtonItems = [self.reloadBarButton]
        self.reloadingActivityIndicator.stopAnimating()
    }
    
    var separatorView : UIView {
        let height = CGFloat(0.5)
        let width = self.view.frame.size.width - (self.separatorInset.left + self.separatorInset.right)
        let x = self.separatorInset.left
        let frame = CGRect(x: x, y: self.tableView.rowHeight - height, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = separatorColor ?? .white
        return view
    }
    var topViewSeparator : UIView {
        let height = CGFloat(0.5)
        let width = self.view.frame.size.width
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = .white
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
        headerView.topItem?.title = headerTitle
        self.headerView.barTintColor = Colors.secondary
        self.view.addSubview(self.topViewSeparator)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !expanded { self.minimize() }
        self.mainView.bringSubview(toFront: self.containerView)
//        self.retrieveRecentGames()
        //enforce only the first initialization of the view position
        if dataLoaded == false {
            adaptToItems()
        }
        
    }
    
    func adaptToItems(reload : Bool = true) {
//        let supposed_y = self.headerHeight + self.tableHeight
//        minimize(origin: false)
//        let candidate_y = self.containerSize.height - viewSize.height
//        let maximum_y_value = self.containerSize.height - (self.headerHeight + self.maxTableHeight)
//        if items.count < 3 && candidate_y > 0 {
//            self.view.frame.origin.y = candidate_y
//        } else if maximum_y_value > 0 {
//            self.view.frame.origin.y = maximum_y_value
//        }
        if reload {
            self.tableView.reloadData()
            if !expanded { self.minimize() } // ensure it has the right dimension after data is loaded
        }
    }
    
    @IBAction func triggerFullScreen(sender : UIPanGestureRecognizer) {
        let up_pan = sender.velocity(in: self.view).y < 0
        
        self.view.removeGestureRecognizer(scrollRecognizer)
        let up_thresold = -self.view.frame.origin.y
        self.traslate(up: up_pan, up_thresold: up_thresold)

    }
    func traslate(up : Bool, up_thresold : CGFloat = 0, animated: Bool = true) {
        var duration = animated ? 0.4 : 0.0
        UIView.animate(withDuration: duration, animations: {
            if up == true {
                self.expand(up_thresold)
                // set the color of the header bar when the view is minimized
                self.headerView.barTintColor = Colors.primary
            } else {
                self.minimize()
                // set the color of the header bar when the view is expanded
                self.headerView.barTintColor = Colors.secondary
            }
            self.headerView.layoutIfNeeded()
            self.containerView.superview!.layoutIfNeeded()
        }) { finish in
            self.expanded = up
            self.mainView.bringSubview(toFront: self.containerView)
            self.view.addGestureRecognizer(self.scrollRecognizer)
            if !self.expanded {
                self.tableView.scrollToTop()
            }
        }
    }
    func getContainerTopConstraint() -> NSLayoutConstraint?
    {
        return (self.containerView.superview!.constraints.filter{ $0.identifier == "recentsTop" }.first)
    }
    private func expand(_ thresold : CGFloat = 0) {
        self.tableView.isScrollEnabled = true
        // change top constaint
//        self.containerView.isHidden = true
        
        if let constraint = self.getContainerTopConstraint() {
            constraint.constant = thresold
            self.containerView.updateConstraints()
        }
//        self.containerView.frame.origin.y = thresold
//        self.view.frame.size.height = self.mainSize.height
//        self.containerView.frame.size.height = self.view.frame.size.height
    }
    private func minimize(origin : Bool = true) {
        self.tableView.isScrollEnabled = false
        if let constraint = self.getContainerTopConstraint() {
            constraint.constant = self.expandedTopConstraintCostant
            self.containerView.updateConstraints()
        }
//        if origin == true {
//            self.containerView.frame.origin.y = self.mainSize.height - self.previousContainerHeight
//        }
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
        guard abs(velocity.y) > 40 else {
            return false
        }
        let up_pan = velocity.y < 0
        let canGoUp = up_pan && !self.expanded
        let canGoDown = !up_pan && self.expanded
        return canGoUp || canGoDown
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y == 0 {
            self.traslate(up: false)
        }
    }
}

extension TPExpandableView : UITableViewDataSource, UITableViewDelegate {
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //se sono arrivato all'inizio, faccio il minimize
        if scrollView.contentOffset.y <= 0 {
            self.traslate(up: false)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        counterLabel.text = items.isEmpty ? "" : "\(items.count)"
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
    func select(item: Base) {
        if let handler = selectedCellHandler {
            handler(item)
        }
    }
    func add(item: Base) {
        self.add(item: item, position: nil)
    }
    func search(item: Base) -> Int? {
        return self.items.index(of: item)
    }
    func add(item: Base, position : Int? = nil) {
        if let index = position {
            self.items.insert(item, at: index)
        } else {
            self.items.append(item)
        }
        let index = position ?? (self.items.count - 1)
        let path = IndexPath(row: index, section: 0)
        self.tableView.insertRows(at: [path], with: .fade)
        if !expanded {
            adaptToItems(reload: false)
        }
    }
    
    func remove(item: Base) {
        guard let index = self.items.index(where: {$0 == item}) else {
            return
        }
        self.items.remove(at: index)
        let path = IndexPath(row: index, section: 0)
        self.tableView.deleteRows(at: [path], with: .fade)
        if !expanded {
            adaptToItems(reload: false)
        }
        
    }
}
