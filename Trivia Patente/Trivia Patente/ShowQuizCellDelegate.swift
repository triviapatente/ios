//
//  QuizViewDelegate.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 28/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

protocol ShowQuizCellDelegate {
    func user_answered(answer : Bool, correct : Bool)
}
