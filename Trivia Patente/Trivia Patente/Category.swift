//
//  Category.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Category: Base, CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kCategoryNameKey: String = "name"


    // MARK: Properties
	public var name: String?


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
		name = json[kCategoryNameKey]

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if name != nil {
			dictionary.updateValue(name!.dictionaryRepresentation(), forKey: kCategoryNameKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.name = aDecoder.decodeObjectForKey(kCategoryNameKey) as? Name

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(name, forKey: kCategoryNameKey)

    }

}
