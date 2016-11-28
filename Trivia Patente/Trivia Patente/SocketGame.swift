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
    func get_categories(round : Round, handler : @escaping (TPRoundCategoryListResponse?) -> Void) {
        SocketGame.emit(path: "get_categories", values: ["round_id": round.id! as AnyObject, "game": round.gameId! as AnyObject], handler: handler)
    }
    func join(game_id : Int, handler : @escaping (TPResponse?) -> Void) {
        SocketGame.join(id: game_id, type: "game", handler: handler)
    }
    func leave(game_id : Int, handler : @escaping (TPResponse?) -> Void) {
        SocketGame.leave(id: game_id, type: "game", handler: handler)
    }
    func get_questions(round : Round, handler : @escaping (TPQuizListResponse?) -> Void) {
        SocketGame.emit(path: "get_questions", values: ["game": round.gameId as AnyObject, "round_id": round.id as AnyObject], handler: handler)
    }
    func choose_category(cat : Category, round : Round, handler: @escaping (TPResponse?) -> Void) {
        SocketGame.emit(path: "choose_category", values: ["category": cat.id as AnyObject, "round_id": round.id as AnyObject, "game": round.gameId as AnyObject], handler: handler)
    }
    func answer(answer : Bool, round : Round, quiz : Quiz, handler: @escaping (TPGameAnswerResponse?) -> Void) {
        SocketGame.emit(path: "answer", values: ["answer": answer as AnyObject, "round_id": round.id! as AnyObject, "game": round.gameId! as AnyObject, "quiz_id": quiz.id! as AnyObject], handler: handler)
    }
    
}
