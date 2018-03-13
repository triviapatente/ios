//
//  GCPageControlViewCollectionViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 12/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

private let reuseIdentifier = "item_cell"

protocol CGPageControlDelegate {
    func customizeCellAt(index: Int, cell: PageControlCollectionViewCell)
    func indexSelected(index: Int)
}

class GCPageControlView: UICollectionViewController {
    
    var numberOfPages : Int = 4
    var numberTitleOffset : Int = 0
    var itemEdgeSize : Int = 24 // change also the property in IB of the collection view
    
    static let UNSELECTED_OPACITY : CGFloat = 0.6
    
    var delegate : CGPageControlDelegate?
    
    var backgroundView : UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        
        self.backgroundView.backgroundColor = UIColor(hex: "#FAFAFA")
        self.view.insertSubview(self.backgroundView, at: 0)
        self.backgroundView.layer.masksToBounds = true
        self.backgroundView.clipsToBounds = false
        self.backgroundView.alpha = GCPageControlView.UNSELECTED_OPACITY
    }
    
    internal func sizeBackgroundView(edges : UIEdgeInsets) {
        let spaceAround = CGFloat(1)
        self.backgroundView.frame = CGRect.init(x: self.view.frame.origin.x + edges.left - spaceAround, y: self.view.frame.origin.y + edges.top - spaceAround, width: self.view.frame.width - edges.left - edges.right + spaceAround.multiplied(by: 2.0), height: CGFloat(itemEdgeSize) + spaceAround.multiplied(by: 2))
        self.backgroundView.circleRounded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        let selected = self.selectedIndex()
        self.collectionView!.reloadData()
        if let index = selected {
            self.collectionView!.selectItem(at: IndexPath.init(row: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
        
//        self.setIndex(to: 0, propagate: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.numberOfPages
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PageControlCollectionViewCell
    
        // Configure the cell
        cell.indexNumber = indexPath.row + self.numberTitleOffset
        if let d = delegate {
            d.customizeCellAt(index: indexPath.row, cell: cell)
        }
        
        return cell
    }
    
    func reloadViewsCustomization() {
        for visible in self.collectionView!.visibleCells {
            let row = self.collectionView!.indexPath(for: visible)!.row
            delegate!.customizeCellAt(index: row, cell: visible as! PageControlCollectionViewCell)
        }
//        self.collectionView!.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemEdgeSize, height: itemEdgeSize)
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setIndex(to: indexPath.row, propagate: true)
        collectionView.isUserInteractionEnabled = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.isUserInteractionEnabled = false
        return true
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    /* INTERFACE */
    func setIndex(to: Int, propagate: Bool = true) {
        if to < numberOfPages {
            var skipSelect = false
            if let s = self.collectionView!.indexPathsForSelectedItems, let f = s.first, f.row == to {
                skipSelect = true
            }
            if !skipSelect {
                self.collectionView!.selectItem(at: IndexPath.init(row: to, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }
            
            if propagate {
                delegate!.indexSelected(index: to)
            }
            
        }
        reloadViewsCustomization()
    }
    
    func selectedIndex() -> Int? {
        guard self.collectionView!.indexPathsForSelectedItems != nil else { return nil }
        guard self.collectionView!.indexPathsForSelectedItems!.first != nil else { return nil }
        return self.collectionView!.indexPathsForSelectedItems!.first!.row
    }
}

extension GCPageControlView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = itemEdgeSize * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 12 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        let edges = UIEdgeInsetsMake(2, leftInset, 2, rightInset)
        sizeBackgroundView(edges: edges)
        return edges
    }
}
