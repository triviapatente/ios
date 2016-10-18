//
//  User.swift
//
//  Created by Luigi Donadel on 18/10/16
//  Copyright (c) TeD. All rights reserved.
//

import Foundation
import SwiftyJSON

public class User: Base, CommonPK {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kUserUsernameKey: String = "username"
	internal let kUserScoreKey: String = "score"
	internal let kUserImageKey: String = "image"
	internal let kUserSurnameKey: String = "surname"
	internal let kUserEmailKey: String = "email"
	internal let kUserNameKey: String = "name"


    // MARK: Properties
	public var username: String?
	public var score: Int?
	public var image: String?
	public var surname: String?
	public var email: String?
	public var name: String?


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
		username = json[kUserUsernameKey].string
		score = json[kUserScoreKey].int
		image = json[kUserImageKey].string
		surname = json[kUserSurnameKey].string
		email = Email(json: json[kUserEmailKey])
		name = json[kUserNameKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if username != nil {
			dictionary.updateValue(username!, forKey: kUserUsernameKey)
		}
		if score != nil {
			dictionary.updateValue(score!, forKey: kUserScoreKey)
		}
		if image != nil {
			dictionary.updateValue(image!, forKey: kUserImageKey)
		}
		if surname != nil {
			dictionary.updateValue(surname!, forKey: kUserSurnameKey)
		}
		if email != nil {
			dictionary.updateValue(email!.dictionaryRepresentation(), forKey: kUserEmailKey)
		}
		if name != nil {
			dictionary.updateValue(name!, forKey: kUserNameKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.username = aDecoder.decodeObjectForKey(kUserUsernameKey) as? String
		self.score = aDecoder.decodeObjectForKey(kUserScoreKey) as? Int
		self.image = aDecoder.decodeObjectForKey(kUserImageKey) as? String
		self.surname = aDecoder.decodeObjectForKey(kUserSurnameKey) as? String
		self.email = aDecoder.decodeObjectForKey(kUserEmailKey) as? Email
		self.name = aDecoder.decodeObjectForKey(kUserNameKey) as? String

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(username, forKey: kUserUsernameKey)
		aCoder.encodeObject(score, forKey: kUserScoreKey)
		aCoder.encodeObject(image, forKey: kUserImageKey)
		aCoder.encodeObject(surname, forKey: kUserSurnameKey)
		aCoder.encodeObject(email, forKey: kUserEmailKey)
		aCoder.encodeObject(name, forKey: kUserNameKey)

    }

}
