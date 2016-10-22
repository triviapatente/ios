//
//  Round.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Round: CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kRoundNumberKey: String = "number"
	internal let kRoundGameIdKey: String = "game_id"
	internal let kRoundCatIdKey: String = "cat_id"
	internal let kRoundDealerIdKey: String = "dealer_id"


    // MARK: Properties
	open var number: Int?
	open var gameId: Int?
	open var catId: Int?
	open var dealerId: Int?


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
		number = json[kRoundNumberKey].int
		gameId = json[kRoundGameIdKey].int
		catId = json[kRoundCatIdKey].int
		dealerId = json[kRoundDealerIdKey].int

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
		if number != nil {
			dictionary.updateValue(number! as AnyObject, forKey: kRoundNumberKey)
		}
		if gameId != nil {
			dictionary.updateValue(gameId! as AnyObject, forKey: kRoundGameIdKey)
		}
		if catId != nil {
			dictionary.updateValue(catId! as AnyObject, forKey: kRoundCatIdKey)
		}
		if dealerId != nil {
			dictionary.updateValue(dealerId! as AnyObject, forKey: kRoundDealerIdKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.number = aDecoder.decodeObject(forKey: kRoundNumberKey) as? Int
		self.gameId = aDecoder.decodeObject(forKey: kRoundGameIdKey) as? Int
		self.catId = aDecoder.decodeObject(forKey: kRoundCatIdKey) as? Int
		self.dealerId = aDecoder.decodeObject(forKey: kRoundDealerIdKey) as? Int

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(number, forKey: kRoundNumberKey)
		aCoder.encode(gameId, forKey: kRoundGameIdKey)
		aCoder.encode(catId, forKey: kRoundCatIdKey)
		aCoder.encode(dealerId, forKey: kRoundDealerIdKey)

    }

}
