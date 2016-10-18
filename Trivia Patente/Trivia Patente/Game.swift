//
//  Game.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Game: Base, CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kGameCreatorIdKey: String = "creator_id"
	internal let kGameWinnerIdKey: String = "winner_id"
	internal let kGameEndedKey: String = "ended"


    // MARK: Properties
	public var creatorId: Int?
	public var winnerId: Int?
	public var ended: Bool = false


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
		creatorId = json[kGameCreatorIdKey].int
		winnerId = json[kGameWinnerIdKey].int
		ended = json[kGameEndedKey].boolValue

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		
		if creatorId != nil {
			dictionary.updateValue(creatorId!, forKey: kGameCreatorIdKey)
		}
		if winnerId != nil {
			dictionary.updateValue(winnerId!, forKey: kGameWinnerIdKey)
		}
		dictionary.updateValue(ended, forKey: kGameEndedKey)

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.winnerId = aDecoder.decodeObjectForKey(kGameWinnerIdKey) as? Int
		self.createdAt = aDecoder.decodeObjectForKey(kGameCreatedAtKey) as? String
		self.ended = aDecoder.decodeBoolForKey(kGameEndedKey)

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(creatorId, forKey: kGameCreatorIdKey)
		aCoder.encodeObject(winnerId, forKey: kGameWinnerIdKey)
		aCoder.encodeBool(ended, forKey: kGameEndedKey)

    }

}
