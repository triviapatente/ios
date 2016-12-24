//
//  TPHeaderView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPGameHeader: UIViewController {

    @IBOutlet var roundLabel : UILabel!
    @IBOutlet var categoryImageView : UIImageView!
    @IBOutlet var categoryNameView : UILabel!
    
    var round : Round! {
        didSet {
            roundLabel.text = "Round \(round.number!)"
        }
    }
    var category : Category! {
        didSet {
            categoryImageView.isHidden = false
            if category != oldValue {
                categoryImageView.load(category: category)
                categoryNameView.text = category.hint
            }
        }
    }
    func set(title : String) {
        categoryImageView.isHidden = true
        categoryNameView.text = title
    }

}
