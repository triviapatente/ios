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
                UIView.animate(withDuration: 0.2, animations: {
                    if self.isSelected
                    {
                        self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                        self.d3Shadow()
                        self.contentView.alpha = 1.0
                    }
                    else
                    {
                        self.transform = CGAffineTransform.identity
                        self.removeShadow()
                        self.contentView.alpha = GCPageControlView.UNSELECTED_OPACITY
                    }
                })
                
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainLabel.layer.borderWidth = CGFloat(3)
        self.mainLabel.layer.borderColor = Colors.light_gray.cgColor
        self.mainLabel.circleRounded()
        self.mainLabel.clipsToBounds = true
        self.contentView.alpha = GCPageControlView.UNSELECTED_OPACITY
    }
}
