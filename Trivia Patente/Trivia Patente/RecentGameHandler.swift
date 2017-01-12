//
//  RecentGameHandler.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 12/01/17.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class RecentGameHandler: TPResponse {
    static var games : [Game] = []
    static var socketHandler = SocketGame()
    static var httpHandler = HTTPGame()
    class func refresh(handler: @escaping () -> Void) {
        httpHandler.recent_games { (response) in
            if response.success == true {
                self.games = response.games.filter({$0.started == true}).map { game in
                    game.opponent = SessionManager.currentUser
                    return game
                }
                handler()
            } else {
                //TODO: add handler
            }
        }
    }
    private static var started : Bool = false
    
    private static let myTurnCheck : (Game) -> Bool = {$0.my_turn == true}
    private static let waitCheck : (Game) -> Bool = {$0.my_turn == false}
    private static let endedCheck : (Game) -> Bool = {$0.ended == true}
    private static let checks = [myTurnCheck, waitCheck, endedCheck]
    
    //indici dell'array
    private static let MY_TURN = 0
    private static let WAIT = 1
    private static let ENDED = 2

    class func indexFor(type : Int) -> Int {
        guard type >= 0 else {
            return 0
        }
        let check = self.checks[type]
        if let index = self.games.index(where: check) {
            return index
        }
        return indexFor(type: type - 1)
    }
    class func typeFor(game : Game) -> Int {
        if game.ended {
            return ENDED
        } else if game.my_turn {
            return MY_TURN
        }
        return WAIT
    }
    class func update(game : Game) {
        let type = self.typeFor(game: game)
        let index = indexFor(type: type)
        self.games.insert(game, at: index)
    }
    class func start(handler : @escaping () -> Void) {
        guard started != true else {
            return
        }
        socketHandler.listen_recent_games { (theEvent) in
            if let event = theEvent {
                let game = event.game!
                self.update(game: game)
                handler()
            }
        }
        self.started = true
    }
    class func stop() {
        self.started = false
        socketHandler.unlisten(events: "recent_game")
    }
}
