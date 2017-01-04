//
//  HeaderTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 04/01/17.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel : UILabel!
    
    var date : Date! {
        didSet {
            self.dateLabel.text = date.prettyDate
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
