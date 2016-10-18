//
//  Round.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Round: Base, CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kRoundNumberKey: String = "number"
	internal let kRoundGameIdKey: String = "game_id"
	internal let kRoundCatIdKey: String = "cat_id"
	internal let kRoundDealerIdKey: String = "dealer_id"


    // MARK: Properties
	public var number: Int?
	public var gameId: Int?
	public var catId: Int?
	public var dealerId: Int?


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
		number = json[kRoundNumberKey].int
		gameId = json[kRoundGameIdKey].int
		catId = json[kRoundCatIdKey].int
		dealerId = json[kRoundDealerIdKey].int

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if number != nil {
			dictionary.updateValue(number!, forKey: kRoundNumberKey)
		}
		if gameId != nil {
			dictionary.updateValue(gameId!, forKey: kRoundGameIdKey)
		}
		if catId != nil {
			dictionary.updateValue(catId!, forKey: kRoundCatIdKey)
		}
		if dealerId != nil {
			dictionary.updateValue(dealerId!, forKey: kRoundDealerIdKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.number = aDecoder.decodeObjectForKey(kRoundNumberKey) as? Int
		self.gameId = aDecoder.decodeObjectForKey(kRoundGameIdKey) as? Int
		self.catId = aDecoder.decodeObjectForKey(kRoundCatIdKey) as? Int
		self.dealerId = aDecoder.decodeObjectForKey(kRoundDealerIdKey) as? Int

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(number, forKey: kRoundNumberKey)
		aCoder.encodeObject(gameId, forKey: kRoundGameIdKey)
		aCoder.encodeObject(catId, forKey: kRoundCatIdKey)
		aCoder.encodeObject(dealerId, forKey: kRoundDealerIdKey)

    }

}
