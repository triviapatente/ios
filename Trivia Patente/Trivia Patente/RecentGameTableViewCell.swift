//
//  RecentGameTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 31/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class RecentGameTableViewCell: TPExpandableTableViewCell {
    @IBOutlet var controlLights : UIImageView!
    @IBOutlet var avatarView : UIImageView!
    @IBOutlet var usernameView : UILabel!
    @IBOutlet var hintView : UILabel!
    @IBOutlet var buttonView : UIButton!
    
    override var item : Base! {
        didSet {
            self.game = item as! Game
        }
    }
    @IBAction func gotoGame() {
        self.delegate.selectCell(for: item)
    }
    var game : Game! {
        didSet {
            changeState(ended: game.ended, my_turn: game.my_turn)
            usernameView.text = game.opponent.username
            //TODO: load async with cache
            avatarView.load(user: game.opponent)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        buttonView.mediumRounded()
        controlLights.mediumRounded()
        avatarView.circleRounded()
        buttonView.layer.borderWidth = 1
    }
    
    func changeState(ended : Bool, my_turn : Bool) {
        let color = buttonColor(ended: ended, my_turn: my_turn)
        let title = buttonText(ended: ended, my_turn: my_turn)
        buttonView.layer.borderColor = color.cgColor
        buttonView.setTitleColor(color, for: .normal)
        buttonView.setTitle(title, for: .normal)
        hintView.text = hint(ended: ended, my_turn: my_turn)
        controlLights.image = lightsImage(ended: ended, my_turn: my_turn)
    }
    func buttonText(ended : Bool, my_turn : Bool) -> String {
        if ended {
            return "Riepilogo"
        } else if my_turn {
            return "Gioca ora"
        } else {
            return "Dettagli"
        }
    }
    func hint(ended : Bool, my_turn : Bool) -> String {
        if ended {
            return "Partita terminata."
        } else if my_turn {
            return "E' il tuo turno!"
        } else {
            return "E' il suo turno.."
        }
    }
    func lightsImage(ended: Bool, my_turn : Bool) -> UIImage {
        if ended {
            return UIImage(named: "red_lights")!
        } else if my_turn {
            return UIImage(named: "green_lights")!
        } else {
            return UIImage(named: "yellow_lights")!
        }
    }
    func buttonColor(ended : Bool, my_turn : Bool) -> UIColor {
        if ended {
            return Colors.red_default
        } else if my_turn {
            return Colors.green_default
        } else {
            return Colors.yellow_default
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
