//
//  Quiz.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Quiz: Base, CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kQuizImageIdKey: String = "image_id"
	internal let kQuizQuestionKey: String = "question"
	internal let kQuizAnswerKey: String = "answer"
	internal let kQuizCategoryIdKey: String = "category_id"


    // MARK: Properties
	public var imageId: Int?
	public var question: String?
	public var answer: Bool = false
	public var categoryId: Int?


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
		imageId = json[kQuizImageIdKey].int
		question = json[kQuizQuestionKey].string
		answer = json[kQuizAnswerKey].boolValue
		categoryId = json[kQuizCategoryIdKey].int

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if imageId != nil {
			dictionary.updateValue(imageId!, forKey: kQuizImageIdKey)
		}
		if question != nil {
			dictionary.updateValue(question!, forKey: kQuizQuestionKey)
		}
		dictionary.updateValue(answer, forKey: kQuizAnswerKey)
		if categoryId != nil {
			dictionary.updateValue(categoryId!, forKey: kQuizCategoryIdKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.imageId = aDecoder.decodeObjectForKey(kQuizImageIdKey) as? Int
		self.question = aDecoder.decodeObjectForKey(kQuizQuestionKey) as? String
		self.answer = aDecoder.decodeBoolForKey(kQuizAnswerKey)
		self.categoryId = aDecoder.decodeObjectForKey(kQuizCategoryIdKey) as? Int

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(imageId, forKey: kQuizImageIdKey)
		aCoder.encodeObject(question, forKey: kQuizQuestionKey)
		aCoder.encodeBool(answer, forKey: kQuizAnswerKey)
		aCoder.encodeObject(categoryId, forKey: kQuizCategoryIdKey)

    }

}
