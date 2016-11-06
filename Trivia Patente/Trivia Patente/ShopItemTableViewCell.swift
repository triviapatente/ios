//
//  ShopItemTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 06/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class ShopItemTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var purchaseButton : UIButton!
    var item : Shopitem! {
        didSet {
            titleLabel.text = "\(item.name!) \(item.emoji!)"
            purchaseButton.setTitle("€ \(item.price!)", for: .normal)
        }
    }
    var callback : ((Shopitem) -> Void)!
    
    @IBAction func requestPurchase() {
        callback(item)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        purchaseButton.mediumRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
