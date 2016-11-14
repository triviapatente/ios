//
//  Base.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Base: NSObject, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kCreatedAtKey: String = "createdAt"
	internal let kUpdatedAtKey: String = "updatedAt"


    // MARK: Properties
    open var updatedAt: Date?
    open var createdAt: Date?


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
        createdAt = json[kCreatedAtKey].stringValue.dateFromGMT
        updatedAt = json[kUpdatedAtKey].stringValue.dateFromGMT

    }
    public override init() {
        createdAt = Date()
        updatedAt = Date()
    }

    subscript(key: String) -> AnyObject? {
        get {
            return self.dictionaryRepresentation()[key]
        }
    }
    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if updatedAt != nil {
			dictionary.updateValue(updatedAt as AnyObject, forKey: kUpdatedAtKey)
		}
		if createdAt != nil {
			dictionary.updateValue(createdAt as AnyObject, forKey: kCreatedAtKey)
		}
		
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.createdAt = (aDecoder.decodeObject(forKey: kCreatedAtKey) as! String).dateFromGMT
        self.updatedAt = (aDecoder.decodeObject(forKey: kUpdatedAtKey) as! String).dateFromGMT
    }

    open func encode(with aCoder: NSCoder) {
		aCoder.encode(createdAt!.gmt, forKey: kCreatedAtKey)
		aCoder.encode(updatedAt!.gmt, forKey: kUpdatedAtKey)

    }

}
