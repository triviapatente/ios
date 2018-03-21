//
//  Category.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Category: CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kCategoryNameKey: String = "name"
    internal let kCategoryHintKey: String = "hint"
    internal let kCategoryTotalAnswersKey: String = "total_answers"
    internal let kCategoryCorrectAnswersKey: String = "correct_answers"

    internal let kCategoryColorKey: String = "color"


    // MARK: Properties
    open var name: String!

    open var color: String?
    open var hint: String?
    open var correct_answers: Int?
    open var total_answers: Int?
    
    var categoryImagesDirectory = "/category/image/"
    var imagePath : String? {
        if let id = self.id {
            return HTTPManager.getBaseURL() + categoryImagesDirectory + "\(id)"
        }
        return nil
    }
    public init(hint: String, id: Int32) {
        super.init(id: id)
        self.hint = hint
    }
    var nativeColor : UIColor {
        return UIColor(hex: color!)
    }
    var progress : Int {
        get {
            guard total_answers != 0 else { return 0 }
            return correct_answers! * 100 / total_answers!
        }
    }
    var status : CategoryStatus {
        get {
            switch progress {
                case _ where progress < 75: return .bad
                case _ where progress < 90: return .medium
                case _ where progress < 95: return .good
                default: return .perfect
            }
        }
    }
    //Convenzione: se l'id della categoria è nullo, allora si tratta della categoria complessiva
    var isOverall : Bool {
        get {
            return id == nil
        }
    }
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
		name = json[kCategoryNameKey].string
        hint = json[kCategoryHintKey].string
        total_answers = json[kCategoryTotalAnswersKey].intValue
        correct_answers = json[kCategoryCorrectAnswersKey].intValue
        color = json[kCategoryColorKey].string
    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
		if name != nil {
			dictionary.updateValue(name as AnyObject, forKey: kCategoryNameKey)
		}
        if hint != nil {
            dictionary.updateValue(hint as AnyObject, forKey: kCategoryHintKey)
        }
        if total_answers != nil {
            dictionary.updateValue(progress as AnyObject, forKey: kCategoryTotalAnswersKey)
        }
        if correct_answers != nil {
            dictionary.updateValue(progress as AnyObject, forKey: kCategoryCorrectAnswersKey)
        }
        if color != nil {
            dictionary.updateValue(color as AnyObject, forKey: kCategoryColorKey)
        }
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.name = aDecoder.decodeObject(forKey: kCategoryNameKey) as? String
        self.hint = aDecoder.decodeObject(forKey: kCategoryHintKey) as? String
        self.total_answers = aDecoder.decodeObject(forKey: kCategoryTotalAnswersKey) as! Int
        self.correct_answers = aDecoder.decodeObject(forKey: kCategoryCorrectAnswersKey) as! Int
        self.color = aDecoder.decodeObject(forKey: kCategoryColorKey) as? String
    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(name, forKey: kCategoryNameKey)
        aCoder.encode(hint, forKey: kCategoryHintKey)
        aCoder.encode(total_answers, forKey: kCategoryTotalAnswersKey)
        aCoder.encode(correct_answers, forKey: kCategoryCorrectAnswersKey)
        aCoder.encode(color, forKey: kCategoryColorKey)

    }

}
