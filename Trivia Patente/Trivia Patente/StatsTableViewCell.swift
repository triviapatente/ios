//
//  StatsTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    @IBOutlet var backgroundLayer : UIView!
    @IBOutlet var nameView : UILabel!
    @IBOutlet var percentageView : UILabel!
    
    @IBOutlet weak var secondaryLabel: UILabel!
    var category : Category! {
        didSet {
            self.nameView.text = category.hint!
            self.percentageView.text = "\(category.progress)%"
            self.secondaryLabel.text = "su \(category.total_quizzes!) quiz totali"
            self.backgroundLayer.backgroundColor = category.status.color
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundLayer.mediumRounded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
