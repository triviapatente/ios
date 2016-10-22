//
//  TPResponse.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class TPResponse {
    var statusCode : Int!
    var message : String!
    var parameters : [String]!
    var success : Bool!
    var json : JSON!
    // MARK: SwiftyJSON Initalizers
    
    /**
     Initates the class based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    required init(object : Data?, statusCode : Int) {
        if let data = object {
            self.load(json: JSON(data: data))
        } else {
            self.success = false
            self.message = "No message from server"
        }
        self.statusCode = statusCode

    }
    required init(error : String, statusCode : Int? = nil) {
        self.success = false
        self.message = error
        if let code = statusCode {
            self.statusCode = code
        }
    }
    func load(json : JSON) {
        self.message = self.json["message"].stringValue
        self.parameters = self.json["parameters"].arrayObject as! [String]
        self.success = self.json["success"].boolValue
    }
}
