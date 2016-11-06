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
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
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
}
