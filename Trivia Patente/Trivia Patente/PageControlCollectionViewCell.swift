//
//  PageControlCollectionViewCell.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 12/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class PageControlCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainLabel: UILabel!
    var indexNumber : Int = -1 {
        didSet {
            self.prepareCell()
        }
    }
    
    private func prepareCell() {
        self.mainLabel.text = "\(indexNumber)"
    }
    
    override var isSelected: Bool{
        didSet{
            DispatchQueue.main.async {
                if self.isSelected
                {
                    self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    self.d3Shadow()
                    self.alpha = 1.0
                }
                else
                {
                    self.transform = CGAffineTransform.identity
                    self.removeShadow()
                    self.alpha = GCPageControlView.UNSELECTED_OPACITY
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.alpha = 0.9
        self.layer.borderWidth = CGFloat(3)
        self.layer.borderColor = Colors.passive_red.cgColor
        self.circleRounded()
    }
}
