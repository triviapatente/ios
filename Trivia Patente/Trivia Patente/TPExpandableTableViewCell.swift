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
    
    func invokeCellHandler() {
        delegate.selectCell(for: item)
    }
}
