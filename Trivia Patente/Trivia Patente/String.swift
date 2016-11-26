//
//  String.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 18/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation



extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
    var dateFromGMT : Date? {
        let date =  Date.Formatter.gmt.date(from: self)
        return date
    }
    
    var isEmail : Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    subscript (r: Range<Int>) -> String {
        get {
            return self
            //let start = self.index
            //let end = self.index(after: r.upperBound - 1)
            //return self.substring(with: start..<end)
        }
    }
}
