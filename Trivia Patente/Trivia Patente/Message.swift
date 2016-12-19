//
//  Message.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Message: CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kMessageContentKey: String = "content"
	internal let kMessageUserIdKey: String = "user_id"
	internal let kMessageGameIdKey: String = "game_id"


    // MARK: Properties
	open var content: String?
	open var userId: Int32?
	open var gameId: Int32?
    
    func isMine() -> Bool {
        return self.userId == SessionManager.currentUser?.id
    }

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
		content = json[kMessageContentKey].string
		userId = json[kMessageUserIdKey].int32
		gameId = json[kMessageGameIdKey].int32

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
		if content != nil {
			dictionary.updateValue(content! as AnyObject, forKey: kMessageContentKey)
		}
		if userId != nil {
			dictionary.updateValue(userId! as AnyObject, forKey: kMessageUserIdKey)
		}
		if gameId != nil {
			dictionary.updateValue(gameId! as AnyObject, forKey: kMessageGameIdKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.content = aDecoder.decodeObject(forKey: kMessageContentKey) as? String
		self.userId = aDecoder.decodeObject(forKey: kMessageUserIdKey) as? Int32
		self.gameId = aDecoder.decodeObject(forKey: kMessageGameIdKey) as? Int32

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(content, forKey: kMessageContentKey)
		aCoder.encode(userId, forKey: kMessageUserIdKey)
		aCoder.encode(gameId, forKey: kMessageGameIdKey)

    }

}
