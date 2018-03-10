//
//  CardCollectionViewLayout.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 10/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class CardCollectionViewLayout: UICollectionViewFlowLayout {
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = self.layoutAttributesForItem(at: itemIndexPath)
        
//        attributes!.center = self.collectionView!.center
        
        return attributes
    }
//
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = self.layoutAttributesForItem(at: itemIndexPath)
        
//        UIView.animate(withDuration: 0.6, animations: {
//            let direction = self.center.x > self.originalLocation.x ? 1.0 : -1.0
            attributes!.center = CGPoint(x: self.collectionView!.center.x * CGFloat(3.5), y: self.collectionView!.center.y)
//        }
        
        return attributes
    }
    override func prepare() {
        self.scrollDirection = .horizontal
        super.prepare()
    }
}
