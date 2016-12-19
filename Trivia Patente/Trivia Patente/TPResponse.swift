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

class TPResponse : CustomStringConvertible {
    var statusCode : Int!
    var message : String!
    var parameters : [String]!
    var success : Bool!
    var json : JSON!
    
    var description: String {
        return "Response (\(statusCode)) success = \(success) message = \(message) json = \(json)"
    }
    // MARK: SwiftyJSON Initalizers
    
    /**
     Initates the class based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    required init(json : JSON?, statusCode : Int? = nil) {
        if let data = json {
            self.load(json: data)
        } else {
            self.success = false
            self.message = "No message from server"
        }
        if let code = statusCode {
            self.statusCode = code
        }

    }
    required init(error : String?, statusCode : Int? = nil, success : Bool = false) {
        self.success = success
        self.message = error
        if let code = statusCode {
            self.statusCode = code
        }
    }
    func load(json : JSON) {
        self.json = json
        self.message = self.json["message"].stringValue
        if let parameters = self.json["parameters"].arrayObject {
            self.parameters = parameters as! [String]
        }
        if let success = self.json["success"].bool {
            self.success = success
        } else {
            self.success = true
        }
        if let statusCode = self.json["status_code"].int {
            self.statusCode = statusCode
        }
    }
}
