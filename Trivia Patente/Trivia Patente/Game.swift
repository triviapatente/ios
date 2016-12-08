//
//  Game.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Game: CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kGameCreatorIdKey: String = "creator_id"
	internal let kGameWinnerIdKey: String = "winner_id"
	internal let kGameEndedKey: String = "ended"
    internal let kGameMyTurnKey: String = "my_turn"
    internal let kGameOpponentNameKey: String = "opponent_username"
    internal let kGameOpponentIdKey: String = "opponent_id"
    internal let kGameOpponentAvatarKey: String = "opponent_image"
    internal let kGameOpponentKey: String = "opponent"


    // MARK: Properties
	open var creatorId: Int?
	open var winnerId: Int?
	open var ended: Bool = false
    open var my_turn : Bool!
    open var opponent : User!

    func won() -> Bool {
        return winnerId == SessionManager.currentUser?.id
    }
    func isEnded() -> Bool {
        return self.ended || self.winnerId != nil
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
		creatorId = json[kGameCreatorIdKey].int
		winnerId = json[kGameWinnerIdKey].int
        ended = json[kGameEndedKey].boolValue
        my_turn = json[kGameMyTurnKey].boolValue
        opponent = User(username: json[kGameOpponentNameKey].string, id: json[kGameOpponentIdKey].int, avatar: json[kGameOpponentAvatarKey].string)
    }

    override init(id: Int?) {
        super.init(id: id)
    }
    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
		
		if creatorId != nil {
			dictionary.updateValue(creatorId! as AnyObject, forKey: kGameCreatorIdKey)
		}
		if winnerId != nil {
			dictionary.updateValue(winnerId! as AnyObject, forKey: kGameWinnerIdKey)
		}
		dictionary.updateValue(ended as AnyObject, forKey: kGameEndedKey)
        dictionary.updateValue(my_turn as AnyObject, forKey: kGameMyTurnKey)
        dictionary.updateValue(opponent.username as AnyObject, forKey: kGameOpponentNameKey)
        dictionary.updateValue(opponent.id as AnyObject, forKey: kGameOpponentIdKey)
        dictionary.updateValue(opponent.image as AnyObject, forKey: kGameOpponentAvatarKey)
        
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.winnerId = aDecoder.decodeObject(forKey: kGameWinnerIdKey) as? Int
        self.creatorId = aDecoder.decodeObject(forKey: kGameCreatorIdKey) as? Int
		self.ended = aDecoder.decodeBool(forKey: kGameEndedKey)
        self.my_turn = aDecoder.decodeBool(forKey: kGameMyTurnKey)
        self.opponent = aDecoder.decodeObject(forKey: kGameOpponentKey) as? User

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(creatorId, forKey: kGameCreatorIdKey)
		aCoder.encode(winnerId, forKey: kGameWinnerIdKey)
		aCoder.encode(ended, forKey: kGameEndedKey)
        aCoder.encode(my_turn, forKey: kGameMyTurnKey)
        aCoder.encode(opponent, forKey: kGameOpponentKey)

    }

}
