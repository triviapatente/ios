//
//  CommonPK.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 18/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation
import SwiftyJSON

open class CommonPK: Base {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kIdKey: String = "id"
    
    
    // MARK: Properties
    open var id: Int32?
    
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the class based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }
    open override func isEqual(_ object: Any?) -> Bool {
        if let instance = object as? CommonPK {
            return type(of: instance) == type(of: self) && instance.id == self.id
        }
        return false
    }
    /**
     Initates the class based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        super.init(json: json)
        id = json[kIdKey].int32
        
    }
    init(id : Int32?) {
        super.init()
        self.id = id
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    open override func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = super.dictionaryRepresentation()
        if id != nil {
            dictionary.updateValue(id! as AnyObject, forKey: kIdKey)
        }
        
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.id = aDecoder.decodeObject(forKey: kIdKey) as? Int32
        
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(id, forKey: kIdKey)
        
    }
    
}
