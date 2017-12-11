//
//  User.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

open class User: CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kUserUsernameKey: String = "username"
	internal let kUserScoreKey: String = "score"
	internal let kUserImageKey: String = "image"
	internal let kUserSurnameKey: String = "surname"
	internal let kUserEmailKey: String = "email"
    internal let kUserNameKey: String = "name"
    internal let kPositionKey: String = "position"
    internal let kLastGameWonKey: String = "last_game_won"
    internal let kSavedImageKey: String = "saved_image"
    internal let kInternalPositionKey: String = "internalPosition"


    // MARK: Properties
	open var username: String?
	open var score: Int?
	open var image: String?
	open var surname: String?
    open var email: String?
    open var name: String?
    open var position: Int32?
    open var internalPosition : Int32?
    open var last_game_won: Bool?
    open var savedImaged : UIImage?
    open var avatarImageUrl : String? {
        return self.image != nil ? HTTPManager.getBaseURL() + "/account/image/\((self.id)!)" : nil
    }
    
    var displayName : String? {
        if let output = self.fullName {
            return output
        }
        return self.username
    }
    var confidentialName : String? {
        return self.name ?? self.username
    }
    
    var initials : String {
        get {
            if (self.name != nil) && (self.surname != nil) {
                return self.name![0] + self.surname![0]
            } else {
                if username!.characters.count > 2
                {
                    return self.username![0...1]
                } else {
                    return self.username!
                }
            }
        }
    }
    
    var fullName : String? {
        get {
            guard name != nil && surname != nil else {
                return nil
            }
            var result = self.name != nil ? self.name! : ""
            result += self.surname != nil ? (" "+self.surname!) : ""
            return result
        }
    }
    func isMe() -> Bool {
        if let current = SessionManager.currentUser {
            return self.id == current.id// self.isEqual(current)
        }
        return false
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
		username = json[kUserUsernameKey].string
		score = json[kUserScoreKey].int
		image = json[kUserImageKey].string
		surname = json[kUserSurnameKey].string
		email = json[kUserEmailKey].string
        name = json[kUserNameKey].string
        position = json[kPositionKey].int32
        last_game_won = json[kLastGameWonKey].bool
        internalPosition = json[kInternalPositionKey].int32
    }
    public init(username : String?, id : Int32?, avatar : String? = nil, name : String? = nil, surname : String? = nil, score : Int? = nil) {
        super.init(id: id)
        self.username = username
        self.image = avatar
        self.score = score
        self.name = name
        self.surname = surname
    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
		if username != nil {
			dictionary.updateValue(username! as AnyObject, forKey: kUserUsernameKey)
		}
		if score != nil {
			dictionary.updateValue(score! as AnyObject, forKey: kUserScoreKey)
		}
		if image != nil {
			dictionary.updateValue(image! as AnyObject, forKey: kUserImageKey)
		}
		if surname != nil {
			dictionary.updateValue(surname! as AnyObject, forKey: kUserSurnameKey)
		}
		if email != nil {
			dictionary.updateValue(email! as AnyObject, forKey: kUserEmailKey)
		}
		if name != nil {
			dictionary.updateValue(name! as AnyObject, forKey: kUserNameKey)
		}
        if position != nil {
            dictionary.updateValue(position! as AnyObject, forKey: kPositionKey)
        }
        if last_game_won != nil {
            dictionary.updateValue(last_game_won! as AnyObject, forKey: kLastGameWonKey)
        }

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		self.username = aDecoder.decodeObject(forKey: kUserUsernameKey) as? String
		self.score = aDecoder.decodeObject(forKey: kUserScoreKey) as? Int
		self.image = aDecoder.decodeObject(forKey: kUserImageKey) as? String
		self.surname = aDecoder.decodeObject(forKey: kUserSurnameKey) as? String
        self.email = aDecoder.decodeObject(forKey: kUserEmailKey) as? String
		self.name = aDecoder.decodeObject(forKey: kUserNameKey) as? String
        self.position = aDecoder.decodeObject(forKey: kPositionKey) as? Int32
        self.internalPosition = aDecoder.decodeObject(forKey: kInternalPositionKey) as? Int32
        self.last_game_won = aDecoder.decodeObject(forKey: kLastGameWonKey) as? Bool
        self.savedImaged = aDecoder.decodeObject(forKey: kSavedImageKey) as? UIImage

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(username, forKey: kUserUsernameKey)
		aCoder.encode(score, forKey: kUserScoreKey)
		aCoder.encode(image, forKey: kUserImageKey)
		aCoder.encode(surname, forKey: kUserSurnameKey)
		aCoder.encode(email, forKey: kUserEmailKey)
        aCoder.encode(name, forKey: kUserNameKey)
        aCoder.encode(last_game_won, forKey: kLastGameWonKey)
        aCoder.encode(savedImaged, forKey: kSavedImageKey)
        aCoder.encode(position, forKey: kPositionKey)
        aCoder.encode(internalPosition, forKey: kInternalPositionKey)
    }

}
