//
//  TPRoundDetailsResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 04/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRoundDetailsResponse: TPResponse {
    var quizzes : [Quiz] = []
    var answers : [Question] = []
    var categories : [Category] = []
    var users : [User] = []
    var scores : [Int] {
        var output = [Int](repeating: 0, count: users.count)
        for answer in answers {
            if let quiz = quizzes.first(where: {$0.id == answer.quizId}) {
                if answer.answer == quiz.answer {
                    if let index = users.index(where: {$0.id == answer.userId}) {
                        output[index] += 1
                    }
                }
            }
        }
        return output
    }
    override func load(json: JSON) {
        super.load(json: json)
        if let rawUsers = json["users"].array {
            for item in rawUsers {
                users.append(User(json: item))
            }
        }
        if let rawQuizzes = json["quizzes"].array {
            for item in rawQuizzes {
                quizzes.append(Quiz(json: item))
            }
        }
        if let rawAnswers = json["answers"].array {
            for item in rawAnswers {
                answers.append(Question(json: item))
            }
        }
        if let rawCategories = json["categories"].array {
            for item in rawCategories {
                categories.append(Category(json: item))
            }
        }
    }
}