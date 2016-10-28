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
    internal let kCategoryStatsKey: String = "stats"


    // MARK: Properties
	open var name: String!
    open var stats: Int!


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
        stats = json[kCategoryStatsKey].intValue

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
        if stats != nil {
            dictionary.updateValue(stats as AnyObject, forKey: kCategoryStatsKey)
        }

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.name = aDecoder.decodeObject(forKey: kCategoryNameKey) as? String
        self.stats = aDecoder.decodeObject(forKey: kCategoryStatsKey) as! Int

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(name, forKey: kCategoryNameKey)
        aCoder.encode(stats, forKey: kCategoryStatsKey)

    }

}
