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
    let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let handler = HTTPPreference()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryView = switchView
        self.loadingView.frame = self.switchView.frame
    }
    override func initValues() {
        super.initValues()
        if let preference = Shared.preferences {
            let key = self.item.key!
            self.switchView.isOn = preference["notification_" + key] as! Bool
            addTarget()
        }
    }
    func addTarget() {
        self.switchView.addTarget(self, action: #selector(switchChange(sender:)), for: .valueChanged)
    }
    func removeTarget() {
        self.switchView.removeTarget(self, action: #selector(switchChange(sender:)), for: .valueChanged)
    }
    func switchChange(sender : UISwitch) {
        removeTarget()
        self.accessoryView = loadingView
        self.loadingView.startAnimating()
        handler.change_notifications(key: self.item.key!, value: sender.isOn) { response in
            self.accessoryView = sender
            if response.success == false {
                sender.isOn = !sender.isOn
                self.addTarget()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
