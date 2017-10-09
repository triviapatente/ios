//
//  ProfilePreferenceTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 13/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class DropdownSettingsTableViewCell: SettingsTableViewCell {

    var labelView = UILabel()
    let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let handler = HTTPPreference()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.labelView.frame = CGRect(x: 0, y: 0, width: 40, height: 100)
        self.labelView.textColor = Colors.primary
        self.configureDropDown()
        self.accessoryView = labelView
        self.loadingView.frame = self.labelView.frame
    }
    func configureDropDown() {
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var selectedValue : String {
        get {
            if let preferences = Shared.preferences {
                let key = self.item.key!
                let visibility = preferences[key] as! PreferenceVisibility
                switch visibility {
                    case .all: return "Tutti"
                    case .friends: return "Amici"
                    case .nobody: return "Nessuno"
                }
            }
            return ""
        }
    }
    func changeValue(newValue : PreferenceVisibility) {
        self.accessoryView = loadingView
        handler.change_others(key: self.item.key!, value: newValue) { response in
            self.accessoryView = self.labelView
            self.labelView.text = self.selectedValue
        }
    }
    override func initValues() {
        super.initValues()
        self.labelView.text = selectedValue
    }
    

}
