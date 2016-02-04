//
//  SPKCardExpiry.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/24/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

/**
 A `NSDateFormatter` to extract the year of a given date.
 */
public class CardExpiry {
    private let month: UInt
    private let year: UInt
    
    /**
     Creates a `CardExpiry` with the given string.
     - parameter string: A string of the form MM/YYYY.
     */
    public convenience init?(string: String) {
        // This should already provide a valid date, which means that no additional checks for invalid months or years are provided:
        let regex = try! NSRegularExpression(pattern: "^(\\d{1,2})?[\\s/]*(\\d{1,2})?", options: .CaseInsensitive)
        var monthStr: String = ""
        var yearStr: String = ""
        
        guard let match = regex.firstMatchInString(string, options: .ReportProgress, range: NSMakeRange(0, string.length())) else {
            return nil
        }
        
        let monthRange = match.rangeAtIndex(1)
        if monthRange.length > 0 {
            if let range = string.rangeFromNSRange(monthRange) {
                monthStr = string.substringWithRange(range)
            } else {
                return nil
            }
        } else {
            return nil
        }
        
        let yearRange = match.rangeAtIndex(2)
        if yearRange.length > 0 {
            if let range = string.rangeFromNSRange(yearRange) {
                yearStr = string.substringWithRange(range)
            }
        }
        
        self.init(month: monthStr, year: yearStr)
    }
    
    /**
     Creates a CardExpiry with the given numeric month and year.
     */
    public init(month: UInt, year: UInt) {
        self.month = month
        self.year = year
    }
    
    /**
     Creates a CardExpiry with the given month and year as String.
     */
    public convenience init?(month: String, year: String) {
        guard let monthVal = UInt(month) where monthVal > 0 && monthVal < 13 else {
            return nil
        }
        guard let yearVal = UInt(year) where yearVal < 100 else {
            return nil
        }
        
        self.init(month: monthVal, year: yearVal)
    }
    
    /**
     Returns the Card expiry date as human readable string with the format MM/YYYY
     */
    public func stringValue() -> String {
        return String(format: "%2i/%2i", arguments: [self.month, self.year % 100])
    }
    
    /**
     - returns: The card's expiry date as `NSDate`, which is equal to the last day of the month specified on the expiry date.
     */
    public func expiryDate() -> NSDate? {
        let dateComponents = NSDateComponents()
        dateComponents.day = 1
        dateComponents.month = Int(self.month)
        dateComponents.year = Int(self.year)
        
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
    }
}
