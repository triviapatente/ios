//
//  RoundDetailsEmptyViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/01/17.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class RoundDetailsEmptyViewController: UIViewController {
    
    @IBOutlet var incrementLabel : UILabel!
    @IBOutlet var stimulationLabel : UILabel!
    @IBOutlet var userImageView : UIImageView!
    @IBOutlet var opponentImageView : UIImageView!
    
    var opponent : User! {
        didSet {
            opponentImageView.load(user: opponent)
        }
    }
    var increment : Int! {
        didSet {
            incrementLabel.text = increment.toSignedString()
        }
    }
    func stimulation(for theUser : User?) -> String {
        if let user = theUser {
            return "Forza \(user.confidentialName!)!"
        }
        return "Forza!"
    }
    func set(opponent : User, increment : Int) {
        self.opponent = opponent
        self.increment = increment
    }
    func configureUI() {
        self.view.bigRounded()
        for imageView in [self.userImageView, self.opponentImageView] {
            imageView?.circleRounded()
            imageView?.layer.borderColor = Colors.primary.cgColor
            imageView?.layer.borderWidth = 1
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        let user = SessionManager.currentUser
        self.userImageView.load(user: user)
        self.opponentImageView.load(user: opponent)
        self.stimulationLabel.text = self.stimulation(for: user)
        
    }
    
}
