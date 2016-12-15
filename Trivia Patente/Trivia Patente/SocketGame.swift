//
//  SocketGame.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class SocketGame: SocketManager {
    func init_round(game_id : Int, handler : @escaping (TPInitRoundResponse?) -> Void) {
        SocketGame.emit(path: "init_round", values: ["game": game_id as AnyObject], handler: handler)
    }
    func get_categories(round : Round, handler : @escaping (TPRoundCategoryListResponse?) -> Void) {
        SocketGame.emit(path: "get_categories", values: ["round_id": round.id! as AnyObject, "game": round.gameId! as AnyObject], handler: handler)
    }
    func join(game_id : Int, handler : @escaping (TPResponse?) -> Void) {
        SocketGame.join(id: game_id, type: "game", handler: handler)
    }
    func listen(event : String, handler : @escaping (TPResponse?) -> Void) {
        SocketGame.listen(event: event, handler: handler)
    }
    func leave(handler : @escaping (TPResponse?) -> Void) {
        SocketGame.leave(type: "game", handler: handler)
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
    func round_details(game_id : Int, handler: @escaping (TPRoundDetailsResponse?) -> Void) {
        SocketGame.emit(path: "round_details", values: ["game": game_id as AnyObject], handler: handler)
    }
    func listen_round_ended(handler: @escaping (TPRoundEndedEvent?) -> Void) {
        SocketGame.listen(event: "round_ended", handler: handler)
    }
    func listen_game_ended(handler: @escaping (TPGameEndedEvent?) -> Void) {
        SocketGame.listen(event: "game_ended", handler: handler)
    }
    func listen_game_left(handler: @escaping (TPGameLeftEvent?) -> Void) {
        SocketGame.listen(event: "game_left", handler: handler)
    }
    func listen_invite_created(handler : @escaping (TPInviteCreatedEvent?) -> Void) {
        SocketGame.listen(event: "invite_created", handler: handler)
    }
    func listen_invite_processed(handler : @escaping (TPInviteProcessedEvent?) -> Void) {
        SocketGame.listen(event: "invite_processed", handler: handler)
    }
    
}
