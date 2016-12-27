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
            changeState(for: game)
            usernameView.text = game.opponent.displayName
            //TODO: load async with cache
            avatarView.load(user: game.opponent)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        buttonView.mediumRounded()
        avatarView.circleRounded()
        buttonView.layer.borderWidth = 1
    }
    
    func changeState(for game : Game) {
        let color = buttonColor(for: game)
        let title = buttonText(for: game)
        buttonView.layer.borderColor = color.cgColor
        buttonView.setTitleColor(color, for: .normal)
        buttonView.setTitle(title, for: .normal)
        hintView.text = hint(for : game)
        controlLights.image = lightsImage(for: game)
    }
    func buttonText(for game : Game) -> String {
        if game.ended {
            return "Riepilogo"
        } else if !game.started {
            return "Chat"
        } else if game.my_turn {
            return "Gioca ora"
        } else {
            return "Dettagli"
        }
    }
    func hint(for game : Game) -> String {
        if game.ended {
            return "Partita terminata."
        } else if !game.started {
            return "Invito inviato!"
        } else if game.my_turn {
            return "E' il tuo turno!"
        } else {
            return "E' il suo turno.."
        }
    }
    func lightsImage(for game : Game) -> UIImage {
        if game.ended {
            return UIImage(named: "traffic_lights_red")!
        } else if !game.started {
            return UIImage(named: "traffic_lights_no_lights")!
        } else if game.my_turn {
            return UIImage(named: "traffic_lights_green")!
        } else {
            return UIImage(named: "traffic_lights_yellow")!
        }
    }
    func buttonColor(for game : Game) -> UIColor {
        if game.ended {
            return Colors.red_default
        } else if !game.started {
            return Colors.gray_default
        } else if game.my_turn {
            return Colors.green_default
        } else {
            return Colors.yellow_default
        }
    }
    
}
