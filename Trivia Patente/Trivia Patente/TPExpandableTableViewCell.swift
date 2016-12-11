//
//  TPRecentTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 12/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPExpandableTableViewCell: UITableViewCell {
    var item : Base!
    var delegate : TPExpandableTableViewCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            delegate.selectCell(for: item)
        }
        // Configure the view for the selected state
    }

}
