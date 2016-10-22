//
//  Quiz.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Quiz: CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kQuizImageIdKey: String = "image_id"
	internal let kQuizQuestionKey: String = "question"
	internal let kQuizAnswerKey: String = "answer"
	internal let kQuizCategoryIdKey: String = "category_id"


    // MARK: Properties
	open var imageId: Int?
	open var question: String?
	open var answer: Bool = false
	open var categoryId: Int?


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
		imageId = json[kQuizImageIdKey].int
		question = json[kQuizQuestionKey].string
		answer = json[kQuizAnswerKey].boolValue
		categoryId = json[kQuizCategoryIdKey].int

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
		if imageId != nil {
			dictionary.updateValue(imageId! as AnyObject, forKey: kQuizImageIdKey)
		}
		if question != nil {
			dictionary.updateValue(question! as AnyObject, forKey: kQuizQuestionKey)
		}
		dictionary.updateValue(answer as AnyObject, forKey: kQuizAnswerKey)
		if categoryId != nil {
			dictionary.updateValue(categoryId! as AnyObject, forKey: kQuizCategoryIdKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.imageId = aDecoder.decodeObject(forKey: kQuizImageIdKey) as? Int
		self.question = aDecoder.decodeObject(forKey: kQuizQuestionKey) as? String
		self.answer = aDecoder.decodeBool(forKey: kQuizAnswerKey)
		self.categoryId = aDecoder.decodeObject(forKey: kQuizCategoryIdKey) as? Int

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(imageId, forKey: kQuizImageIdKey)
		aCoder.encode(question, forKey: kQuizQuestionKey)
		aCoder.encode(answer, forKey: kQuizAnswerKey)
		aCoder.encode(categoryId, forKey: kQuizCategoryIdKey)

    }

}
