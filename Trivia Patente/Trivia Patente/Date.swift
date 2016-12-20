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
            formatter.locale = defaultLocale
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

        static let current : DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar.current
            formatter.locale = defaultLocale
            formatter.timeZone = TimeZone.current
            return formatter
        }()
        static let simple : DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = defaultLocale
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }
    static var defaultLocale : Locale = {
        return Locale(identifier: "it_IT")
    }()
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
    func isLastYear() -> Bool {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year], from: Date())
        components.calendar = calendar
        components.day = 1
        components.month = 1
        let date = components.date!
        return self < date
    }
    var prettyTime : String {
        Formatter.current.dateFormat = "HH:mm"
        return Formatter.current.string(from: self)
    }
    var withoutTime : Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        var newComponents = DateComponents()
        newComponents.calendar = calendar
        newComponents.day = components.day
        newComponents.month = components.month
        newComponents.year = components.year
        return newComponents.date
    }
    var prettyDate : String {
        if self.isToday() {
            return "Oggi"
        } else if self.isYesterday() {
            return "Ieri"
        }
        var format = "dd MMMM"
        if self.isLastYear() {
            format += " YYYY"
        }
        Formatter.current.dateFormat = format
        return Formatter.current.string(from: self)
    }
}
