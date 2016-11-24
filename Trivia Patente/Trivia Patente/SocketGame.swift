//
//  SocketGame.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class SocketGame: SocketManager {
    func init_round(game_id : Int, number : Int, handler : @escaping (TPInitRoundResponse?) -> Void) {
        SocketGame.emit(path: "init_round", values: ["game": game_id as AnyObject, "number": number as AnyObject], handler: handler)
    }
}
