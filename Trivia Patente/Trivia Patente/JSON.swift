//
//  JSON.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    static func fromData(data: Data?) -> JSON? {
        if let candidate = data {
            return JSON(data: candidate)
        }
        return nil
    }
    
    static func fromDict(dict: [String : AnyObject]?) -> JSON? {
        if let candidate = dict {
            return JSON(json: candidate)
        }
        return nil
    }
}
