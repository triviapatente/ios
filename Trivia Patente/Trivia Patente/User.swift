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


    // MARK: Properties
	open var username: String?
	open var score: Int?
	open var image: String?
	open var surname: String?
	open var email: String?
	open var name: String?


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

    }
    public init(username : String?, id : Int?, avatar : String?) {
        super.init(id: id)
        self.username = username
        self.image = avatar
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

    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
		aCoder.encode(username, forKey: kUserUsernameKey)
		aCoder.encode(score, forKey: kUserScoreKey)
		aCoder.encode(image, forKey: kUserImageKey)
		aCoder.encode(surname, forKey: kUserSurnameKey)
		aCoder.encode(email, forKey: kUserEmailKey)
		aCoder.encode(name, forKey: kUserNameKey)

    }

}
