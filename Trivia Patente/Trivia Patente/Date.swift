//
//  Date.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 18/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            return formatter
        }()
        static let gmt : DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar.current
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss ZZZZ"
            return formatter
        }()
    }
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    var gmt : String {
        return Formatter.gmt.string(from: self)
    }
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    func isYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    var pretty : String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        if self.isToday() || self.isYesterday() {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "dd/MM"
        }
        let output = formatter.string(from: self)
        if self.isToday() {
            return "Oggi, \(output)"
        } else if self.isYesterday() {
            return "Ieri, \(output)"
        }
        return output
    }
}
