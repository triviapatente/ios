//
//  ProposedCategoryTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class ProposedCategoryTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var categoryImageView : UIImageView!
    @IBOutlet var imageContainerView : UIView!
    
    var color : UIColor! {
        didSet {
            self.imageContainerView.backgroundColor = color
            self.imageContainerView.layer.borderColor = color.darker(offset: 0.2).cgColor
        }
    }
    var category : Category! {
        didSet {
            self.categoryImageView.load(category: category)
            self.nameLabel.text = category.hint
            self.color = category.nativeColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageContainerView.circleRounded()
        self.imageContainerView.layer.borderWidth = 3
        // Initialization code
    }
    
    
}
