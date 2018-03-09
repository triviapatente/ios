//
//  Colors.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 26/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class Colors {
    static let primary = UIColor(red: 0/255, green: 170/255, blue: 255/255, alpha: 1)
    static let secondary = UIColor(red: 1/255, green: 112/255, blue: 255/255, alpha: 1)
    
    static let alpha_white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.67)
    
    static let playColor = UIColor(red: 0/255, green: 213/255, blue: 101/255, alpha: 1)
    static let rankColor = UIColor(red: 255/255, green: 144/255, blue: 0/255, alpha: 1)
    static let trainingColor = UIColor(red: 238/255, green: 206/255, blue: 41/255, alpha: 1)
    static let shopColor = UIColor(red: 255/255, green: 55/255, blue: 39/255, alpha: 1)
    static let statsColor = UIColor(red: 251/255, green: 99/255, blue: 253/255, alpha: 1)
    
    static let green_default = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    static let yellow_default = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
    static let red_default = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
    static let orange_default = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
    static let gray_default = UIColor(red: 91/255, green: 91/255, blue: 91/255, alpha: 1)
    
    static let stats_perfect = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    static let stats_good = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
    static let stats_medium = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
    static let stats_bad = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
    
    static let correct_default = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
    static let error_default = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)

    static let accept_color = UIColor(red: 25/255, green: 221/255, blue: 109/255, alpha: 1)
    static let refuse_color = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
    
    // colors for the login&register controllers background gradient
    static let access_top_color = UIColor(red: 8/255, green: 222/255, blue: 255/255, alpha: 1)
    static let access_bottom_color = UIColor(red: 0/255, green: 192/255, blue: 255/255, alpha: 1)
    
    static let button_highlighted_color = UIColor(red: 3/255, green: 97/255, blue: 188/255, alpha: 1)
    static let text_highlight = UIColor(red: 132/255, green: 249/255, blue: 182/255, alpha: 1)
    
    static let passive_red = UIColor(red: 237/255, green: 97/255, blue: 89/255, alpha: 1)
    
    // get gradient for access controllers
    static func accessGradientLayer(view: UIView) -> CAGradientLayer
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [Colors.primary.cgColor, Colors.secondary.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }
}
