//
//  Shopitem.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Shopitem: Base, CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kShopitemPriceKey: String = "price"
	internal let kShopitemEmojiKey: String = "emoji"
	internal let kShopitemNameKey: String = "name"


    // MARK: Properties
	public var price: String?
	public var emoji: String?
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
		price = Price(json: json[kShopitemPriceKey])
		emoji = json[kShopitemEmojiKey].string
		name = json[kShopitemNameKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if price != nil {
			dictionary.updateValue(price!.dictionaryRepresentation(), forKey: kShopitemPriceKey)
		}
		if emoji != nil {
			dictionary.updateValue(emoji!, forKey: kShopitemEmojiKey)
		}
		if name != nil {
			dictionary.updateValue(name!, forKey: kShopitemNameKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.price = aDecoder.decodeObjectForKey(kShopitemPriceKey) as? Price
		self.emoji = aDecoder.decodeObjectForKey(kShopitemEmojiKey) as? String
		self.name = aDecoder.decodeObjectForKey(kShopitemNameKey) as? String

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(price, forKey: kShopitemPriceKey)
		aCoder.encodeObject(emoji, forKey: kShopitemEmojiKey)
		aCoder.encodeObject(name, forKey: kShopitemNameKey)

    }

}
