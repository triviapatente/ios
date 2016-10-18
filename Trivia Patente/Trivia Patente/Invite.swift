//
//  Invite.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Invite: Base {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kInviteAcceptedKey: String = "accepted"
	internal let kInviteReceiverIdKey: String = "receiver_id"
	internal let kInviteSenderIdKey: String = "sender_id"
	internal let kInviteGameIdKey: String = "game_id"


    // MARK: Properties
	public var accepted: Bool = false
	public var receiverId: Int?
	public var senderId: Int?
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
		accepted = json[kInviteAcceptedKey].boolValue
		receiverId = json[kInviteReceiverIdKey].int
		senderId = json[kInviteSenderIdKey].int
		gameId = json[kInviteGameIdKey].int

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		dictionary.updateValue(accepted, forKey: kInviteAcceptedKey)
		if receiverId != nil {
			dictionary.updateValue(receiverId!, forKey: kInviteReceiverIdKey)
		}
		if senderId != nil {
			dictionary.updateValue(senderId!, forKey: kInviteSenderIdKey)
		}
		if gameId != nil {
			dictionary.updateValue(gameId!, forKey: kInviteGameIdKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.accepted = aDecoder.decodeBoolForKey(kInviteAcceptedKey)
		self.receiverId = aDecoder.decodeObjectForKey(kInviteReceiverIdKey) as? Int
		self.senderId = aDecoder.decodeObjectForKey(kInviteSenderIdKey) as? Int
		self.gameId = aDecoder.decodeObjectForKey(kInviteGameIdKey) as? Int

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeBool(accepted, forKey: kInviteAcceptedKey)
		aCoder.encodeObject(receiverId, forKey: kInviteReceiverIdKey)
		aCoder.encodeObject(senderId, forKey: kInviteSenderIdKey)
		aCoder.encodeObject(gameId, forKey: kInviteGameIdKey)

    }

}
