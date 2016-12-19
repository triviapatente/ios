//
//  Question.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Question: Base {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kQuestionAnswerKey: String = "answer"
    internal let kQuestionUserIdKey: String = "user_id"
    internal let kQuestionUserKey: String = "user"
	internal let kQuestionQuizIdKey: String = "quiz_id"
    internal let kQuestionRoundIdKey: String = "round_id"
    internal let kQuestionRoundNumberKey: String = "round_number"


    // MARK: Properties
	open var answer: Bool = false
	open var userId: Int32?
	open var quizId: Int32?
    open var roundId: Int32?
    open var roundNumber: Int?
    
    var user : User!


    // MARK: SwiftyJSON Initalizers
    /**
    Initates the class based on the object
    - parameter object: The object of either Dictionary or Array kind that was passed.
    - returns: An initalized instance of the class.
    */
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }

    /**
    Initates the class based on the JSON that was passed.
    - parameter json: JSON object from SwiftyJSON.
    - returns: An initalized instance of the class.
    */
    public required init(json: JSON) {
        super.init(json: json)
		answer = json[kQuestionAnswerKey].boolValue
		userId = json[kQuestionUserIdKey].int32
		quizId = json[kQuestionQuizIdKey].int32
		roundId = json[kQuestionRoundIdKey].int32
        roundNumber = json[kQuestionRoundNumberKey].int
    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
		dictionary.updateValue(answer as AnyObject, forKey: kQuestionAnswerKey)
		if userId != nil {
			dictionary.updateValue(userId! as AnyObject, forKey: kQuestionUserIdKey)
		}
		if quizId != nil {
			dictionary.updateValue(quizId! as AnyObject, forKey: kQuestionQuizIdKey)
		}
		if roundId != nil {
			dictionary.updateValue(roundId! as AnyObject, forKey: kQuestionRoundIdKey)
		}
        if roundNumber != nil {
            dictionary.updateValue(roundNumber! as AnyObject, forKey: kQuestionRoundNumberKey)
        }

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.answer = aDecoder.decodeBool(forKey: kQuestionAnswerKey)
		self.userId = aDecoder.decodeObject(forKey: kQuestionUserIdKey) as? Int32
		self.quizId = aDecoder.decodeObject(forKey: kQuestionQuizIdKey) as? Int32
		self.roundId = aDecoder.decodeObject(forKey: kQuestionRoundIdKey) as? Int32
        self.roundNumber = aDecoder.decodeObject(forKey: kQuestionRoundNumberKey) as? Int
        self.user = aDecoder.decodeObject(forKey: kQuestionUserKey) as? User

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(answer, forKey: kQuestionAnswerKey)
		aCoder.encode(userId, forKey: kQuestionUserIdKey)
		aCoder.encode(quizId, forKey: kQuestionQuizIdKey)
        aCoder.encode(roundId, forKey: kQuestionRoundIdKey)
        aCoder.encode(roundNumber, forKey: kQuestionRoundNumberKey)
        aCoder.encode(user, forKey: kQuestionUserKey)

    }

}
