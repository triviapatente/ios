//
//  TrainingQuizCollectionViewCell.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 08/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class TrainingQuizCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainButton: QuizScoreButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    var item : Training? {
        didSet {
            loadView()
        }
    }
    
    func loadView() {
        self.mainButton.setScore(scoreNumber: item!.numberOfErrors)
    }
    

}
