//
//  Training.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 15/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Training : CommonPK {
    
    internal let kQuestionsKey: String = "questions"
    internal let kStatsKey: String = "stats"
    
    open var questions : [Quiz]?
    open var numberOfErrors : Int32?
    
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }
    
    convenience init() {
        self.init(json: JSON([]))
    }
    
    /**
     Initates the class based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        super.init(json: json)
        if let questionsJSON = json[kQuestionsKey].array {
            questions = []
            for questionsJSON in questionsJSON {
                self.questions!.append(Quiz(json: questionsJSON))
            }
        }
        numberOfErrors = json[kStatsKey].int32
    }
    
    open override func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
        
        if questions != nil {
            dictionary.updateValue(questions! as AnyObject, forKey: kQuestionsKey)
        }
        if numberOfErrors != nil {
            dictionary.updateValue(numberOfErrors! as AnyObject, forKey: kStatsKey)
        }
        
        
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.questions = aDecoder.decodeObject(forKey: kQuestionsKey) as? [Quiz]
        self.numberOfErrors = aDecoder.decodeObject(forKey: kStatsKey) as? Int32
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(questions, forKey: kQuestionsKey)
        aCoder.encode(numberOfErrors, forKey: kStatsKey)
    }
    
    func getQuestionsAnswerAsDictionary() -> [String : Bool] {
        guard self.questions != nil else { return [:] }
        var dict : [String : Bool] = [:]
        for question in self.questions! {
            if let answer = question.my_answer {
                dict["\(question.id!)"] = answer
            }
        }
        return dict
    }
}

