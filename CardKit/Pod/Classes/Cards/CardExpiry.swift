//
//  SPKCardExpiry.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/24/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

public class CardExpiry {
    private var monthString: String?
    private var yearString: String?

    public lazy var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()

    public convenience init(string: String?) {
        guard let string = string else {
            self.init(month: "", year: "")
            return
        }

        do {
            let regex = try NSRegularExpression(pattern: "^(\\d{1,2})?[\\s/]*(\\d{1,4})?", options: .CaseInsensitive)
            let match = regex.firstMatchInString(string, options: .ReportProgress, range: NSMakeRange(0, string.length()))
            var monthStr: String = ""
            var yearStr: String = ""

            if let match = match {
                let monthRange = match.rangeAtIndex(1)
                if monthRange.length > 0 {
                    if let range = string.rangeFromNSRange(monthRange) {
                        monthStr = string.substringWithRange(range)
                    }
                }

                let yearRange = match.rangeAtIndex(2)
                if yearRange.length > 0 {
                    if let range = string.rangeFromNSRange(yearRange) {
                        yearStr = string.substringWithRange(range)
                    }
                }
            }

            self.init(month: monthStr, year: yearStr)
        } catch {
            print("Got an error while generating regular expression")
            self.init(month: "", year: "")
        }
    }

    public convenience init(month: Int, year: Int) {
        var monthStr = String(format: "%lu", arguments: [month])
        let yearStr = String(format: "%lu", arguments: [year])
        if monthStr.length() == 1 {
            monthStr = String(format: "0%@", arguments: [monthStr])
        }

        self.init(month: monthStr, year: yearStr)
    }

    public init(month: String, year: String) {
        monthString = month
        yearString = year

        if let monthString = monthString {
            if monthString.length() == 1 {
                if monthString != "0" && monthString != "1" {
                    self.monthString = String(format: "0%@", arguments: [monthString])
                }
            }
        }
    }

    public func formattedString() -> String? {
        if let yearString = yearString, let monthString = monthString {
            if yearString.length() > 0 {
                return String(format: "%@/%@", arguments: [monthString, yearString])
            } else {
                return String(format: "%@", arguments: [monthString])
            }
        } else {
            return nil
        }
    }

    public func formattedStringWithTrail() -> String? {
        if let yearString = yearString, let monthString = monthString {
            if monthString.length() == 2 && yearString.length() == 0 {
                if let formattedString = formattedString() {
                    return String(format: "%@/", arguments: [formattedString])
                }
            } else {
                return formattedString()
            }
        }
        return nil
    }

    public func string() -> String? {
        return formattedString()
    }

    public func isValid() -> Bool {
        return isValidLength() && isValidDate()
    }

    public func isPartiallyValid() -> Bool {
        if isValidLength() {
            return isValidDate()
        } else {
            if let month = month(), let yearString = yearString {
                return month <= 12 && yearString.length() <= 4
            } else {
                return false
            }
        }
    }

    public func month() -> Int? {
        if let monthString = monthString {
            return Int(monthString)
        }
        return nil
    }

    public func year() -> Int? {
        if var yearString = yearString {
            if yearString.length() == 2 {
                var prefix = dateFormatter.stringFromDate(NSDate())
                if let range = prefix.rangeFromNSRange(NSMakeRange(0, 2)) {
                    prefix = prefix.substringWithRange(range)
                    yearString = String(format: "%@%@", arguments: [prefix, yearString])
                }
            }
            return Int(yearString)
        }
        return nil
    }

    private func isValidLength() -> Bool {
        if let monthString = monthString, let yearString = yearString {
            return monthString.length() == 2 && (yearString.length() == 2 || yearString.length() == 4)
        } else {
            return false
        }
    }

    private func isValidDate() -> Bool {
        if let month = month() {
            if month <= 0 || month > 12 {
                return false
            } else {
                return isValidWithDate(NSDate())
            }
        }
        return false
    }

    private func isValidWithDate(date: NSDate) -> Bool {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let unitFlags: NSCalendarUnit = [.Month, .Year]
        let dateComponents = gregorianCalendar?.components(unitFlags, fromDate: date)
        if dateComponents?.year < year() {
            return true
        } else if dateComponents?.year == year() {
            return dateComponents?.month <= month()
        }
        return false
    }

    public func expiryDate() -> NSDate? {
        if let month = month(), let year = year() {
            let dateComponents = NSDateComponents()
            dateComponents.day = 1
            dateComponents.month = month
            dateComponents.year = year

            if let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian),
                let components = gregorianCalendar.dateFromComponents(dateComponents) {
                let monthRange = gregorianCalendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month,
                    forDate:components)

                dateComponents.day = monthRange.length
                dateComponents.hour = 23
                dateComponents.minute = 59

                return gregorianCalendar.dateFromComponents(dateComponents)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
