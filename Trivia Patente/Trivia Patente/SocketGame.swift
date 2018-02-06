//
//  SocketGame.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 24/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class SocketGame: SocketManager {
    
    var handlerIDs : [UUID] = []
    
    func init_round(game_id : Int32, handler : @escaping (TPInitRoundResponse) -> Void) {
        SocketManager.emit(path: "init_round", values: ["game": game_id as AnyObject], handler: handler)
    }
    func get_categories(round : Round, handler : @escaping (TPRoundCategoryListResponse) -> Void) {
        SocketManager.emit(path: "get_categories", values: ["round_id": round.id! as AnyObject, "game": round.gameId! as AnyObject], handler: handler)
    }
    func get_questions(round : Round, handler : @escaping (TPQuizListResponse) -> Void) {
        SocketManager.emit(path: "get_questions", values: ["game": round.gameId as AnyObject, "round_id": round.id as AnyObject], handler: handler)
    }
    func choose_category(cat : Category, round : Round, handler: @escaping (TPResponse) -> Void) {
        SocketManager.emit(path: "choose_category", values: ["category": cat.id as AnyObject, "round_id": round.id as AnyObject, "game": round.gameId as AnyObject], handler: handler)
    }
    func answer(answer : Bool, round : Round, quiz : Quiz, handler: @escaping (TPGameAnswerResponse) -> Void) {
        SocketManager.emit(path: "answer", values: ["answer": answer as AnyObject, "round_id": round.id! as AnyObject, "game": round.gameId! as AnyObject, "quiz_id": quiz.id! as AnyObject], handler: handler)
    }
    func round_details(game_id : Int32, handler: @escaping (TPRoundDetailsResponse) -> Void) {
        SocketManager.emit(path: "round_details", values: ["game": game_id as AnyObject], handler: handler)
    }
    func join(game_id : Int32, handler : @escaping (TPResponse) -> Void) {
        SocketManager.join(id: game_id, type: "game", handler: handler)
    }
    func listen<T: TPResponse>(event : String, handler : @escaping (T) -> Void) {
        let eventHandlerID = SocketManager.listen(event: event, handler: handler)
        self.handlerIDs.append(eventHandlerID)
    }
    func unlisten(events : String...) {
        SocketManager.unlisten(events: events)
    }
    func leave(handler : @escaping (TPResponse) -> Void) {
        SocketManager.leave(type: "game", handler: handler)
    }
    func listen_round_ended(handler: @escaping (TPResponse) -> Void) {
        self.listen(event: "round_ended", handler: handler)
    }
    func listen_round_started(handler: @escaping (TPRoundStartedEvent) -> Void) {
        self.listen(event: "round_started", handler: handler)
    }
    func listen_user_answered(handler: @escaping (TPQuestionAnsweredEvent) -> Void) {
        self.listen(event: "user_answered", handler: handler)
    }
    func listen_game_ended(handler: @escaping (TPGameEndedEvent) -> Void) {
        self.listen(event: "game_ended", handler: handler)
    }
    func listen_game_left(handler: @escaping (TPGameLeftEvent) -> Void) {
        self.listen(event: "game_left", handler: handler)
    }
    func listen_user_left_game(handler: @escaping (TPGameEndedEvent) -> Void) {
        self.listen(event: "user_left_game", handler: handler)
    }
    func listen_recent_games(handler: @escaping (TPRecentGameEvent) -> Void) {
        self.listen(event: "recent_game", handler: handler)
    }
    func unlistenAllEvents() {
        SocketManager.unlisten(handlerIds: self.handlerIDs)
    }
    
}
