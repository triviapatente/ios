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
    internal let kQuizMyAnswerKey: String = "my_answer"
    internal let kQuizCategoryIdKey: String = "category_id"
    internal let kQuizAnsweredCorrectlyKey: String = "answered_correctly"
    internal let kQuizRoundIdKey : String = "round_id"
    internal let kQuizCategoryName : String = "category_name"


    // MARK: Properties
	open var imageId: Int32?
	open var question: String?
    open var answer: Bool?
    open var my_answer: Bool?
	open var categoryId: Int32?
    open var answeredCorrectly : Bool?
    open var roundId : Int32?
    open var categoryName : String?

    var imagePath : String? {
        get {
            if let id = imageId {
                return HTTPManager.getBaseURL() + "/quiz/image/\(id)"
            }
            return nil
        }
    }
    var answers : [Question] = []

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
		imageId = json[kQuizImageIdKey].int32
		question = json[kQuizQuestionKey].string
        answer = json[kQuizAnswerKey].bool
        my_answer = json[kQuizMyAnswerKey].bool
		categoryId = json[kQuizCategoryIdKey].int32
        answeredCorrectly = json[kQuizAnsweredCorrectlyKey].bool
        roundId = json[kQuizRoundIdKey].int32
        categoryName = json[kQuizCategoryName].string
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
        if my_answer != nil {
            dictionary.updateValue(my_answer! as AnyObject, forKey: kQuizMyAnswerKey)
        }
        if categoryId != nil {
			dictionary.updateValue(categoryId! as AnyObject, forKey: kQuizCategoryIdKey)
		}
        if roundId != nil {
            dictionary.updateValue(roundId! as AnyObject, forKey: kQuizRoundIdKey)
        }
        if categoryName != nil {
            dictionary.updateValue(roundId! as AnyObject, forKey: kQuizCategoryName)
        }
        dictionary.updateValue(answeredCorrectly as AnyObject, forKey: kQuizAnsweredCorrectlyKey)

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.imageId = aDecoder.decodeObject(forKey: kQuizImageIdKey) as? Int32
		self.question = aDecoder.decodeObject(forKey: kQuizQuestionKey) as? String
		self.answer = aDecoder.decodeBool(forKey: kQuizAnswerKey)
        self.my_answer = aDecoder.decodeBool(forKey: kQuizMyAnswerKey)
		self.categoryId = aDecoder.decodeObject(forKey: kQuizCategoryIdKey) as? Int32
        self.answeredCorrectly = aDecoder.decodeBool(forKey: kQuizAnsweredCorrectlyKey)
        self.roundId = aDecoder.decodeInt32(forKey: kQuizRoundIdKey)
        self.categoryName = aDecoder.decodeObject(forKey: kQuizCategoryName) as? String
    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(imageId, forKey: kQuizImageIdKey)
		aCoder.encode(question, forKey: kQuizQuestionKey)
        aCoder.encode(answer, forKey: kQuizAnswerKey)
        aCoder.encode(my_answer, forKey: kQuizAnswerKey)
		aCoder.encode(categoryId, forKey: kQuizCategoryIdKey)
        aCoder.encode(answeredCorrectly, forKey: kQuizAnsweredCorrectlyKey)
        aCoder.encode(roundId, forKey: kQuizRoundIdKey)
        aCoder.encode(categoryName, forKey: kQuizCategoryName)
    }

}
