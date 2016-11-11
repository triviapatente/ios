//
//  CategoryStatus.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

enum CategoryStatus : String {
    case perfect = "Congratulazioni!\nLa tua media è da promozione!\nContinua così!"
    case good = "La tua media è da promozione, ma puoi fare ancora meglio!"
    case medium = "Cerca di alzare la tua media! Puoi esercitarti sfidando i tuoi amici!"
    case bad = "Devi assolutamente migliorare, esercitati di più sfidando i tuoi amici!"
    
    var color : UIColor {
        get {
            switch(self) {
                case .perfect: return Colors.stats_perfect
                case .good: return Colors.stats_good
                case .medium: return Colors.stats_medium
                case .bad: return Colors.stats_bad
            }
        }
    }
}
