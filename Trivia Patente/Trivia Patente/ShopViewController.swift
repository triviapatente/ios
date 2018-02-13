//
//  ShopViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 06/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD

class ShopViewController: TPNormalViewController {

    @IBOutlet var tableView : UITableView!
    @IBOutlet var alreadyInfinityView : UIView!

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
    
    //TODO: set this variable from user info
    var alreadyInfinity = false
    
    @IBAction func toggleInfinityView() {
        if alreadyInfinity {
            alreadyInfinityView.isHidden = !alreadyInfinityView.isHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonCallback = { item in
            //TODO: implement shop request callback
            print(item)
        }
        let nib = UINib(nibName: "ShopItemTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "shopitem_cell")
        
        if !alreadyInfinity {
            preparePurchaseView()
        } else {
            prepareMockView()
        }
        alreadyInfinityView.isHidden = !alreadyInfinity
        self.tableView.isUserInteractionEnabled = !alreadyInfinity
        
    }
    func prepareMockView() {
        let a = Shopitem(id: 1, name: "Sei", price: 0, emoji: "❤️")
        let b = Shopitem(id: 2, name: "un", price: 0, emoji: "❤️")
        let c = Shopitem(id: 3, name: "fantastico", price: 0, emoji: "❤️")
        let d = Shopitem(id: 4, name: "utente!", price: 0, emoji: "❤️")
        self.items = [a, b, c, d]
    }
    func preparePurchaseView() {
        self.tableView.rowHeight = MIN_CELL_HEIGHT
        loadingView = MBProgressHUD.clearAndShow(to: self.view, animated: true)
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
        guard self.items.count > 0 else {
            return
        }
        let candidate = self.tableView.frame.size.height / CGFloat(self.items.count)
        //se la dimensione candidata è minore del minimo, non la posso accettare, quindi devo abilitare lo scroll in quanto la somma delle altezze delle celle supererà l'altezza della view
        self.tableView.isScrollEnabled = candidate < MIN_CELL_HEIGHT
        self.tableView.rowHeight = max(candidate, MIN_CELL_HEIGHT)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopitem_cell") as! ShopItemTableViewCell
        cell.item = items[indexPath.row]
        cell.callback = self.buttonCallback
        return cell
    }
    
}
