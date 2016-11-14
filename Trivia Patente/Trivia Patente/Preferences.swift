//
//  Preferences.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Preferences: CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kPreferencesStatsKey: String = "stats"
	internal let kPreferencesNotificationMessageKey: String = "notification_message"
	internal let kPreferencesChatKey: String = "chat"
	internal let kPreferencesNotificationRoundKey: String = "notification_round"
	internal let kPreferencesUserIdKey: String = "user_id"
	internal let kPreferencesNotificationNewGameKey: String = "notification_new_game"
	internal let kPreferencesNotificationFullHeartsKey: String = "notification_full_hearts"


    // MARK: Properties
    var stats: PreferenceVisibility?
	open var notificationMessage: Bool = false
    var chat: PreferenceVisibility?
	open var notificationRound: Bool = false
	open var userId: Int?
	open var notificationNewGame: Bool = false
	open var notificationFullHearts: Bool = false


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
		stats = PreferenceVisibility(rawValue: json[kPreferencesStatsKey].stringValue)
		notificationMessage = json[kPreferencesNotificationMessageKey].boolValue
        chat = PreferenceVisibility(rawValue: json[kPreferencesChatKey].stringValue)
		notificationRound = json[kPreferencesNotificationRoundKey].boolValue
		userId = json[kPreferencesUserIdKey].int
		notificationNewGame = json[kPreferencesNotificationNewGameKey].boolValue
		notificationFullHearts = json[kPreferencesNotificationFullHeartsKey].boolValue

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
		
		if stats != nil {
			dictionary.updateValue(stats as AnyObject, forKey: kPreferencesStatsKey)
		}
		dictionary.updateValue(notificationMessage as AnyObject, forKey: kPreferencesNotificationMessageKey)
		
		if chat != nil {
			dictionary.updateValue(chat as AnyObject, forKey: kPreferencesChatKey)
		}
		dictionary.updateValue(notificationRound as AnyObject, forKey: kPreferencesNotificationRoundKey)
		if userId != nil {
			dictionary.updateValue(userId! as AnyObject, forKey: kPreferencesUserIdKey)
		}
		dictionary.updateValue(notificationNewGame as AnyObject, forKey: kPreferencesNotificationNewGameKey)
		
		dictionary.updateValue(notificationFullHearts as AnyObject, forKey: kPreferencesNotificationFullHeartsKey)

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.stats = aDecoder.decodeObject(forKey: kPreferencesStatsKey) as! PreferenceVisibility?
		self.notificationMessage = aDecoder.decodeBool(forKey: kPreferencesNotificationMessageKey)
		self.chat = aDecoder.decodeObject(forKey: kPreferencesChatKey) as! PreferenceVisibility?
		self.notificationRound = aDecoder.decodeBool(forKey: kPreferencesNotificationRoundKey)
		self.userId = aDecoder.decodeObject(forKey: kPreferencesUserIdKey) as? Int
		self.notificationNewGame = aDecoder.decodeBool(forKey: kPreferencesNotificationNewGameKey)
		self.notificationFullHearts = aDecoder.decodeBool(forKey: kPreferencesNotificationFullHeartsKey)

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(stats, forKey: kPreferencesStatsKey)
		aCoder.encode(notificationMessage, forKey: kPreferencesNotificationMessageKey)
		aCoder.encode(chat, forKey: kPreferencesChatKey)
		aCoder.encode(notificationRound, forKey: kPreferencesNotificationRoundKey)
		aCoder.encode(userId, forKey: kPreferencesUserIdKey)
		aCoder.encode(notificationNewGame, forKey: kPreferencesNotificationNewGameKey)
		aCoder.encode(notificationFullHearts, forKey: kPreferencesNotificationFullHeartsKey)

    }

}
