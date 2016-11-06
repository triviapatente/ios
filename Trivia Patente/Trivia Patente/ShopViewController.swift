//
//  ShopViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 06/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class ShopViewController: UITableViewController {

    var items : [Shopitem] = [] {
        didSet {
            self.configureCellHeight()
            self.tableView.reloadData()
        }
    }
    var buttonCallback : ((Shopitem) -> Void)!
    
    let handler = HTTPShop()
    
    let MIN_CELL_HEIGHT = CGFloat(100)
    
    var loadingView : MBProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ShopItemTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "shopitem_cell")
        self.buttonCallback = { item in
            //TODO: implement shop request callback
            print(item)
        }
        
        loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingView.mode = .indeterminate
        handler.shop_items { response in
            self.loadingView.hide(animated: true)
            if response.success == true {
                self.items = response.items
            } else {
                //TODO: handle error
            }
        }
        
    }
    
    func configureCellHeight() {
        let candidate = self.view.frame.size.height / CGFloat(self.items.count)
        //se la dimensione candidata è minore del minimo, non la posso accettare, quindi devo abilitare lo scroll in quanto la somma delle altezze delle celle supererà l'altezza della view
        self.tableView.isScrollEnabled = candidate < MIN_CELL_HEIGHT
        self.tableView.rowHeight = max(candidate, MIN_CELL_HEIGHT)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShopViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopitem_cell") as! ShopItemTableViewCell
        cell.item = items[indexPath.row]
        cell.callback = self.buttonCallback
        return cell
    }
    
}
