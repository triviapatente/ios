//
//  Invite.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Invite: Base {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kInviteAcceptedKey: String = "accepted"
	internal let kInviteReceiverIdKey: String = "receiver_id"
	internal let kInviteSenderIdKey: String = "sender_id"
	internal let kInviteGameIdKey: String = "game_id"


    // MARK: Properties
	open var accepted: Bool = false
	open var receiverId: Int?
	open var senderId: Int?
	open var gameId: Int?


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
		accepted = json[kInviteAcceptedKey].boolValue
		receiverId = json[kInviteReceiverIdKey].int
		senderId = json[kInviteSenderIdKey].int
		gameId = json[kInviteGameIdKey].int

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
		dictionary.updateValue(accepted as AnyObject, forKey: kInviteAcceptedKey)
		if receiverId != nil {
			dictionary.updateValue(receiverId! as AnyObject, forKey: kInviteReceiverIdKey)
		}
		if senderId != nil {
			dictionary.updateValue(senderId! as AnyObject, forKey: kInviteSenderIdKey)
		}
		if gameId != nil {
			dictionary.updateValue(gameId! as AnyObject, forKey: kInviteGameIdKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.accepted = aDecoder.decodeBool(forKey: kInviteAcceptedKey)
		self.receiverId = aDecoder.decodeObject(forKey: kInviteReceiverIdKey) as? Int
		self.senderId = aDecoder.decodeObject(forKey: kInviteSenderIdKey) as? Int
		self.gameId = aDecoder.decodeObject(forKey: kInviteGameIdKey) as? Int

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(accepted, forKey: kInviteAcceptedKey)
		aCoder.encode(receiverId, forKey: kInviteReceiverIdKey)
		aCoder.encode(senderId, forKey: kInviteSenderIdKey)
		aCoder.encode(gameId, forKey: kInviteGameIdKey)

    }

}
