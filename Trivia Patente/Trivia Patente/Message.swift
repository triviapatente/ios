//
//  Message.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Message: Base, CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kMessageContentKey: String = "content"
	internal let kMessageUserIdKey: String = "user_id"
	internal let kMessageGameIdKey: String = "game_id"


    // MARK: Properties
	public var content: String?
	public var userId: Int?
	public var gameId: Int?


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
		content = json[kMessageContentKey].string
		userId = json[kMessageUserIdKey].int
		gameId = json[kMessageGameIdKey].int

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if content != nil {
			dictionary.updateValue(content!, forKey: kMessageContentKey)
		}
		if userId != nil {
			dictionary.updateValue(userId!, forKey: kMessageUserIdKey)
		}
		if gameId != nil {
			dictionary.updateValue(gameId!, forKey: kMessageGameIdKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.content = aDecoder.decodeObjectForKey(kMessageContentKey) as? String
		self.userId = aDecoder.decodeObjectForKey(kMessageUserIdKey) as? Int
		self.gameId = aDecoder.decodeObjectForKey(kMessageGameIdKey) as? Int

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(content, forKey: kMessageContentKey)
		aCoder.encodeObject(userId, forKey: kMessageUserIdKey)
		aCoder.encodeObject(gameId, forKey: kMessageGameIdKey)

    }

}
