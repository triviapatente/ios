//
//  HTTPTraining.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 15/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import Foundation

class HTTPTraining : HTTPManager {
    func get_training(training_id: Int32, handler : @escaping (TPTrainingResponse) -> Void) {
        _ = self.request(url: "/training/\(training_id)", method: .get, params: nil, handler: handler)
    }
    func list_trainings(handler : @escaping (TPTrainingsListResponse) -> Void) {
        _ = self.request(url: "/training/all", method: .get, params: nil, handler: handler)
    }
    func new_training(answers: [String: Any], handler : @escaping (TPNewTrainingResponse) -> Void) {
        _ = self.request(url: "/training/new", method: .post, params: ["answers" : answers], jsonBody: true, handler: handler)
    }
    func get_new_training_questions(random: Bool, handler : @escaping (TPTrainingResponse) -> Void) {
        _ = self.request(url: "/training/new", method: .get, params: ["random": random], handler: handler)
    }
}
