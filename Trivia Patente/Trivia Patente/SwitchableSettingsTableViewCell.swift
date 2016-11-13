//
//  SwitchablePreferenceTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 13/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class SwitchableSettingsTableViewCell: SettingsTableViewCell {
    var switchView = UISwitch()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryView = switchView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
