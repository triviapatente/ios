//
//  Base.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Base: NSObject, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kCreatedAtKey: String = "createdAt"
	internal let kUpdatedAtKey: String = "updatedAt"


    // MARK: Properties
    public var updatedAt: Date?
    public var createdAt: Date?


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
        createdAt = (json[kCreatedAtKey] as! String).dateFromISO8601()
        updatedAt = (json[kupdatedAtKey] as! String).dateFromISO8601()

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if updatedAt != nil {
			dictionary.updateValue(updatedAt, forKey: kUpdatedAtKey)
		}
		if createdAt != nil {
			dictionary.updateValue(createdAt, forKey: kCreatedAtKey)
		}
		
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.createdAt = (aDecoder.decodeObjectForKey(kCreatedAtKey) as! String).dateFromISO8601
        self.updatedAt = (aDecoder.decodeObjectForKey(kUpdatedAtKey) as! String).dateFromISO8601
    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(createdAt, forKey: kCreatedAtKey)
		aCoder.encodeObject(updatedAt, forKey: kUpdatedAtKey)

    }

}
