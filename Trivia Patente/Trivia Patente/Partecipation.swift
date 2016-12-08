//
//  Partecipation.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 08/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//
//

import Foundation
import SwiftyJSON

open class Partecipation: Base {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kPartecipationScoreIncrementKey: String = "score_increment"
    internal let kPartecipationUserIdKey: String = "user_id"
    internal let kPartecipationGameIdKey: String = "game_id"
    
    
    // MARK: Properties
    open var scoreIncrement: Int?
    open var userId: Int?
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
    
    func isMine() -> Bool {
        return self.userId == SessionManager.currentUser?.id
    }
    /**
     Initates the class based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        super.init(json: json)
        gameId = json[kPartecipationGameIdKey].int
        userId = json[kPartecipationUserIdKey].int
        scoreIncrement = json[kPartecipationScoreIncrementKey].int
    }
    
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
        if scoreIncrement != nil {
            dictionary.updateValue(scoreIncrement! as AnyObject, forKey: kPartecipationScoreIncrementKey)
        }
        if userId != nil {
            dictionary.updateValue(userId! as AnyObject, forKey: kPartecipationUserIdKey)
        }
        if gameId != nil {
            dictionary.updateValue(gameId! as AnyObject, forKey: kPartecipationGameIdKey)
        }
        
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scoreIncrement = aDecoder.decodeObject(forKey: kPartecipationScoreIncrementKey) as? Int
        self.userId = aDecoder.decodeObject(forKey: kPartecipationUserIdKey) as? Int
        self.gameId = aDecoder.decodeObject(forKey: kPartecipationGameIdKey) as? Int
        
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(scoreIncrement, forKey: kPartecipationScoreIncrementKey)
        aCoder.encode(userId, forKey: kPartecipationUserIdKey)
        aCoder.encode(gameId, forKey: kPartecipationGameIdKey)
        
    }
    
}

