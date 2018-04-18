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
    internal let kGameStartedKey: String = "started"
    internal let kGameMyTurnKey: String = "my_turn"
    internal let kGameOpponentUsernameKey: String = "opponent_username"
    internal let kGameOpponentIdKey: String = "opponent_id"
    internal let kGameOpponentNameKey: String = "opponent_name"
    internal let kGameOpponentSurnameKey: String = "opponent_surname"
    internal let kGameOpponentAvatarKey: String = "opponent_image"
    internal let kGameOpponentKey: String = "opponent"
    internal let kGameRemainingAnswersCountKey: String = "remaining_answers_count"
    internal let kGameMyScoreKey: String = "my_score"
    internal let kGameOpponentScoreKey: String = "opponent_score"
    internal let kGameExpiredKey: String = "expired"


    // MARK: Properties
	open var creatorId: Int32?
	open var winnerId: Int32?
	open var ended: Bool = false
    open var started: Bool = false
    open var my_turn : Bool = false
    open var opponent : User!
    open var incomplete : Bool = false
    open var remainingAnswersCount : Int!
    open var myScore : Int!
    open var opponentScore : Int!
    open var expired : Bool!

    func won() -> Bool {
        return winnerId == SessionManager.currentUser?.id
    }
    func isEnded() -> Bool {
        return self.ended || self.winnerId != nil
    }
    func isNotEnded() -> Bool {
        return !self.isEnded()
    }
    func isWinner(user : User) -> Bool {
        return user.id == self.winnerId
    }
    func cancelled() -> Bool {
        return self.isEnded() && !self.started
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
		creatorId = json[kGameCreatorIdKey].int32
		winnerId = json[kGameWinnerIdKey].int32
        ended = json[kGameEndedKey].boolValue
        my_turn = json[kGameMyTurnKey].boolValue
        started = json[kGameStartedKey].boolValue
        myScore = json[kGameMyScoreKey].intValue
        expired = json[kGameExpiredKey].boolValue
        opponentScore = json[kGameOpponentScoreKey].intValue
        remainingAnswersCount = json[kGameRemainingAnswersCountKey].intValue
        opponent = User(username: json[kGameOpponentUsernameKey].string, id: json[kGameOpponentIdKey].int32, avatar: json[kGameOpponentAvatarKey].string, name: json[kGameOpponentNameKey].string, surname: json[kGameOpponentSurnameKey].string)
    }

    override init(id: Int32?) {
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
        dictionary.updateValue(opponent.dictionaryRepresentation() as AnyObject, forKey: kGameOpponentKey)
        dictionary.updateValue(started as AnyObject, forKey: kGameStartedKey)
        dictionary.updateValue(expired as AnyObject, forKey: kGameExpiredKey)
        dictionary.updateValue(myScore as AnyObject, forKey: kGameMyScoreKey)
        dictionary.updateValue(opponentScore as AnyObject, forKey: kGameOpponentScoreKey)
        dictionary.updateValue(remainingAnswersCount as AnyObject, forKey: kGameRemainingAnswersCountKey)
        
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.winnerId = aDecoder.decodeObject(forKey: kGameWinnerIdKey) as? Int32
        self.creatorId = aDecoder.decodeObject(forKey: kGameCreatorIdKey) as? Int32
		self.ended = aDecoder.decodeBool(forKey: kGameEndedKey)
        self.started = aDecoder.decodeBool(forKey: kGameStartedKey)
        self.my_turn = aDecoder.decodeBool(forKey: kGameMyTurnKey)
        self.expired = aDecoder.decodeBool(forKey: kGameExpiredKey)
        self.opponent = aDecoder.decodeObject(forKey: kGameOpponentKey) as? User
        self.remainingAnswersCount = aDecoder.decodeObject(forKey: kGameRemainingAnswersCountKey) as? Int
        self.myScore = aDecoder.decodeObject(forKey: kGameMyScoreKey) as? Int
        self.opponentScore = aDecoder.decodeObject(forKey: kGameOpponentScoreKey) as? Int

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(creatorId, forKey: kGameCreatorIdKey)
		aCoder.encode(winnerId, forKey: kGameWinnerIdKey)
		aCoder.encode(ended, forKey: kGameEndedKey)
        aCoder.encode(my_turn, forKey: kGameMyTurnKey)
        aCoder.encode(opponent, forKey: kGameOpponentKey)
        aCoder.encode(started, forKey: kGameStartedKey)
        aCoder.encode(expired, forKey: kGameExpiredKey)
        aCoder.encode(remainingAnswersCount, forKey: kGameRemainingAnswersCountKey)
        aCoder.encode(myScore, forKey: kGameMyScoreKey)
        aCoder.encode(opponentScore, forKey: kGameOpponentScoreKey)
    }

}
