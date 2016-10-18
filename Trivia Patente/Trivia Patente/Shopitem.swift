//
//  Shopitem.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Shopitem: CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kShopitemPriceKey: String = "price"
	internal let kShopitemEmojiKey: String = "emoji"
	internal let kShopitemNameKey: String = "name"


    // MARK: Properties
	open var price: String?
	open var emoji: String?
	open var name: String?


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
    public override init(json: JSON) {
        super.init(json: json)
		price = json[kShopitemPriceKey].string
		emoji = json[kShopitemEmojiKey].string
		name = json[kShopitemNameKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
		if price != nil {
			dictionary.updateValue(price! as AnyObject, forKey: kShopitemPriceKey)
		}
		if emoji != nil {
			dictionary.updateValue(emoji! as AnyObject, forKey: kShopitemEmojiKey)
		}
		if name != nil {
			dictionary.updateValue(name! as AnyObject, forKey: kShopitemNameKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.price = aDecoder.decodeObject(forKey: kShopitemPriceKey) as? String
		self.emoji = aDecoder.decodeObject(forKey: kShopitemEmojiKey) as? String
		self.name = aDecoder.decodeObject(forKey: kShopitemNameKey) as? String

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(price, forKey: kShopitemPriceKey)
		aCoder.encode(emoji, forKey: kShopitemEmojiKey)
		aCoder.encode(name, forKey: kShopitemNameKey)

    }

}
