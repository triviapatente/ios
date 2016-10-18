//
//  Question.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Question: Base {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kQuestionAnswerKey: String = "answer"
	internal let kQuestionUserIdKey: String = "user_id"
	internal let kQuestionQuizIdKey: String = "quiz_id"
	internal let kQuestionRoundIdKey: String = "round_id"


    // MARK: Properties
	public var answer: Bool = false
	public var userId: Int?
	public var quizId: Int?
	public var roundId: Int?


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
    public init(json: JSON) {
		answer = json[kQuestionAnswerKey].boolValue
		userId = json[kQuestionUserIdKey].int
		quizId = json[kQuestionQuizIdKey].int
		roundId = json[kQuestionRoundIdKey].int

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		dictionary.updateValue(answer, forKey: kQuestionAnswerKey)
		if userId != nil {
			dictionary.updateValue(userId!, forKey: kQuestionUserIdKey)
		}
		if quizId != nil {
			dictionary.updateValue(quizId!, forKey: kQuestionQuizIdKey)
		}
		if roundId != nil {
			dictionary.updateValue(roundId!, forKey: kQuestionRoundIdKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.answer = aDecoder.decodeBoolForKey(kQuestionAnswerKey)
		self.userId = aDecoder.decodeObjectForKey(kQuestionUserIdKey) as? Int
		self.quizId = aDecoder.decodeObjectForKey(kQuestionQuizIdKey) as? Int
		self.roundId = aDecoder.decodeObjectForKey(kQuestionRoundIdKey) as? Int

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeBool(answer, forKey: kQuestionAnswerKey)
		aCoder.encodeObject(userId, forKey: kQuestionUserIdKey)
		aCoder.encodeObject(quizId, forKey: kQuestionQuizIdKey)
		aCoder.encodeObject(roundId, forKey: kQuestionRoundIdKey)

    }

}
