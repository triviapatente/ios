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
    override func initValues() {
        super.initValues()
        if let preference = Shared.preferences {
            let key = self.item.key!
            self.switchView.isOn = preference[key] as! Bool
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
