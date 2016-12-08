//
//  TPSectionBarTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 08/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPSectionBarTableViewCell: UITableViewCell {
    @IBOutlet var valueLabel : UILabel!
    @IBOutlet var circleView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.circleView.circleRounded()
    }
    func configureView(selected : Bool = false) {
        self.valueLabel.textColor = selected ? Colors.primary : Colors.alpha_white
        self.circleView.backgroundColor = selected ? Colors.alpha_white : Colors.primary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.configureView(selected: selected)
    }
    
}
