//
//  PreferencesTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 13/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    var item : PreferenceItem! {
        didSet {
            initValues()
        }
    }
    func initValues() {
        if let title = item.title {
            self.textLabel?.text = title
        }
        if let image = item.image {
            if let imageView = self.imageView {
                imageView.clipsToBounds = true
                imageView.contentMode = .center
                imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                imageView.image = UIImage(named: image)
            }
            
        }
        if item.type == .normal {
            self.accessoryType = .disclosureIndicator
        }
        if let _ = item.segue {
            self.selectionStyle = .gray
        } else {
            self.selectionStyle = .none
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
