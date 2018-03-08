//
//  TrainingQuizCollectionViewCell.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 08/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class TrainingQuizCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainButton.circleRounded()
    }
    
    private var item : Int = 0
    
    func setItem(value: Int) {
        self.mainButton.setTitle("\(value)", for: .normal)
        self.mainButton.setImage(nil, for: .normal)
        var color = Colors.red_default
        if value < 5 {
            color = Colors.orange_default
        }
        if value < 3 {
            color = Colors.yellow_default
        }
        if value < 1{
            color = Colors.green_default
            self.mainButton.setTitle(nil, for: .normal)
            self.mainButton.setImage(UIImage(named: "simple_tick"), for: .normal)
        }
        self.setColor(color: color)
    }
    
    private func setColor(color: UIColor) {
        self.mainButton.backgroundColor = color
        self.mainButton.darkerBorder(of: 0.1, width: 2.5)
    }
}
