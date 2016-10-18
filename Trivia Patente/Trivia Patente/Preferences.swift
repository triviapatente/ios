//
//  Preferences.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Preferences: Base, CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kPreferencesStatsKey: String = "stats"
	internal let kPreferencesNotificationMessageKey: String = "notification_message"
	internal let kPreferencesChatKey: String = "chat"
	internal let kPreferencesNotificationRoundKey: String = "notification_round"
	internal let kPreferencesUserIdKey: String = "user_id"
	internal let kPreferencesNotificationNewGameKey: String = "notification_new_game"
	internal let kPreferencesNotificationFullHeartsKey: String = "notification_full_hearts"


    // MARK: Properties
	public var stats: String? //TODO: make enum
	public var notificationMessage: Bool = false
    public var chat: String? //TODO: make enum
	public var notificationRound: Bool = false
	public var userId: Int?
	public var notificationNewGame: Bool = false
	public var notificationFullHearts: Bool = false


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
		stats = Stats(json: json[kPreferencesStatsKey])
		notificationMessage = json[kPreferencesNotificationMessageKey].boolValue
		chat = Chat(json: json[kPreferencesChatKey])
		notificationRound = json[kPreferencesNotificationRoundKey].boolValue
		userId = json[kPreferencesUserIdKey].int
		notificationNewGame = json[kPreferencesNotificationNewGameKey].boolValue
		notificationFullHearts = json[kPreferencesNotificationFullHeartsKey].boolValue

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		
		if stats != nil {
			dictionary.updateValue(stats!.dictionaryRepresentation(), forKey: kPreferencesStatsKey)
		}
		dictionary.updateValue(notificationMessage, forKey: kPreferencesNotificationMessageKey)
		
		if chat != nil {
			dictionary.updateValue(chat!.dictionaryRepresentation(), forKey: kPreferencesChatKey)
		}
		dictionary.updateValue(notificationRound, forKey: kPreferencesNotificationRoundKey)
		if userId != nil {
			dictionary.updateValue(userId!, forKey: kPreferencesUserIdKey)
		}
		dictionary.updateValue(notificationNewGame, forKey: kPreferencesNotificationNewGameKey)
		
		dictionary.updateValue(notificationFullHearts, forKey: kPreferencesNotificationFullHeartsKey)

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.updatedAt = aDecoder.decodeObjectForKey(kPreferencesUpdatedAtKey) as? String
		self.stats = aDecoder.decodeObjectForKey(kPreferencesStatsKey) as? Stats
		self.notificationMessage = aDecoder.decodeBoolForKey(kPreferencesNotificationMessageKey)
		self.internalIdentifier = aDecoder.decodeObjectForKey(kPreferencesInternalIdentifierKey) as? Int
		self.chat = aDecoder.decodeObjectForKey(kPreferencesChatKey) as? Chat
		self.notificationRound = aDecoder.decodeBoolForKey(kPreferencesNotificationRoundKey)
		self.userId = aDecoder.decodeObjectForKey(kPreferencesUserIdKey) as? Int
		self.notificationNewGame = aDecoder.decodeBoolForKey(kPreferencesNotificationNewGameKey)
		self.createdAt = aDecoder.decodeObjectForKey(kPreferencesCreatedAtKey) as? String
		self.notificationFullHearts = aDecoder.decodeBoolForKey(kPreferencesNotificationFullHeartsKey)

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(updatedAt, forKey: kPreferencesUpdatedAtKey)
		aCoder.encodeObject(stats, forKey: kPreferencesStatsKey)
		aCoder.encodeBool(notificationMessage, forKey: kPreferencesNotificationMessageKey)
		aCoder.encodeObject(internalIdentifier, forKey: kPreferencesInternalIdentifierKey)
		aCoder.encodeObject(chat, forKey: kPreferencesChatKey)
		aCoder.encodeBool(notificationRound, forKey: kPreferencesNotificationRoundKey)
		aCoder.encodeObject(userId, forKey: kPreferencesUserIdKey)
		aCoder.encodeBool(notificationNewGame, forKey: kPreferencesNotificationNewGameKey)
		aCoder.encodeObject(createdAt, forKey: kPreferencesCreatedAtKey)
		aCoder.encodeBool(notificationFullHearts, forKey: kPreferencesNotificationFullHeartsKey)

    }

}
