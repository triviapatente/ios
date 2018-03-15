//
//  TrainingStats.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 15/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import Foundation
import SwiftyJSON

class TrainingStats : Base {
    internal let kTotalTrainingsKey: String = "total"
    internal let kCorrectTrainingsKey: String = "correct"
    internal let k1_2ErrorTrainingsKey : String = "1_2errors"
    internal let k3_4errorsTrainingsKey : String = "3_4errors"
    internal let kMoreErrorsTrainingsKey : String = "more_errors"
    
    open var total: Int32!
    open var correct: Int32!
    open var errors1_2: Int32!
    open var errors3_4: Int32!
    open var moreErrors: Int32!
    
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON) {
        super.init(json: json)
        total = json[kTotalTrainingsKey].int32
        correct = json[kCorrectTrainingsKey].int32
        moreErrors = json[kMoreErrorsTrainingsKey].int32
        errors1_2 = json[k1_2ErrorTrainingsKey].int32
        errors3_4 = json[k3_4errorsTrainingsKey].int32
    }
    
    open override func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
      
        dictionary.updateValue(total as AnyObject, forKey: kTotalTrainingsKey)
        dictionary.updateValue(correct as AnyObject, forKey: kCorrectTrainingsKey)
        dictionary.updateValue(moreErrors as AnyObject, forKey: kMoreErrorsTrainingsKey)
        dictionary.updateValue(errors3_4 as AnyObject, forKey: k3_4errorsTrainingsKey)
        dictionary.updateValue(errors1_2 as AnyObject, forKey: k1_2ErrorTrainingsKey)
        
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.total = aDecoder.decodeObject(forKey: kTotalTrainingsKey) as? Int32
        self.moreErrors = aDecoder.decodeObject(forKey: kMoreErrorsTrainingsKey) as? Int32
        self.correct = aDecoder.decodeObject(forKey: kCorrectTrainingsKey) as? Int32
        self.errors3_4 = aDecoder.decodeObject(forKey: k3_4errorsTrainingsKey) as? Int32
        self.errors1_2 = aDecoder.decodeObject(forKey: k1_2ErrorTrainingsKey) as? Int32
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(total, forKey: kTotalTrainingsKey)
        aCoder.encode(correct, forKey: kCorrectTrainingsKey)
        aCoder.encode(moreErrors, forKey: kMoreErrorsTrainingsKey)
        aCoder.encode(errors3_4, forKey: k3_4errorsTrainingsKey)
        aCoder.encode(errors1_2, forKey: k1_2ErrorTrainingsKey)
    }
}
