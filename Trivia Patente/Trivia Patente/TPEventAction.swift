//
//  TPEventAction.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 12/01/17.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

enum TPEventAction : String {
    case create = "create"
    case update = "update"
    case destroy = "destroy"
    
    static func from(event : String) -> TPEventAction? {
        switch event {
            case create.rawValue: return create
            case update.rawValue: return update
            case destroy.rawValue: return destroy
            default: return nil
        }
    }
    
}
