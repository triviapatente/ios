//
//  FBInfos.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 19/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SwiftyJSON

class FBInfos : NSObject, NSCoding {
    let kHasTokenKey = "has_token";
    let kExpirationKey = "expiration"
    
    var hasToken : Bool!
    var expiration : Date!
    
    var expired : Bool {
        return expiration <= Date()
    }
    public init(json: JSON) {
        hasToken = json[kHasTokenKey].bool
        expiration = json[kExpirationKey].string?.dateFromISO8601
        
    }

    public required init(coder aDecoder: NSCoder) {
        self.hasToken = aDecoder.decodeObject(forKey: kHasTokenKey) as? Bool
        self.expiration = aDecoder.decodeObject(forKey: kExpirationKey) as? Date
        
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(hasToken, forKey: kHasTokenKey)
        aCoder.encode(expiration, forKey: kExpirationKey)
        
    }
}
