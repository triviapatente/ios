//
//  PreferenceItem.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 13/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class PreferenceItem {
    var image : String?
    var title : String?
    var dropdownValues : [String] = ["Tutti", "Amici", "Nessuno"]
    var type : PreferenceType!
    var segue : String?
    var height : CGFloat!
    var key : String?
    
    init(title : String? = nil, image : String? = nil, type : PreferenceType = .normal, dropdownValues : [String]? = nil, segue : String? = nil, height : CGFloat = 50, key : String? = nil) {
        self.title = title
        self.image = image
        self.type = type
        if let values = dropdownValues {
            self.dropdownValues = values
        }
        self.segue = segue
        self.height = height
        self.key = key
    }
}
