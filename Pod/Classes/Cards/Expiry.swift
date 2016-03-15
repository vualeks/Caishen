//
//  Expiry.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/24/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

private extension NSDate {
    func year() -> Int? {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        return gregorianCalendar?.components(.Year, fromDate: self).year
    }
}

/**
 A `NSDateFormatter` to extract the year of a given date.
 */
public class Expiry {

    /**
     Having a year like "16", the numberPrefix is used to complete the year.
     In this example: "16" -> "2016"
     */
    private static let numberPrefix: UInt = 2000
    private static let maxYear: UInt = 2099
    private static let minYear: UInt = 2000

    private let month: UInt
    private let year: UInt
    
    /**
     Creates a `CardExpiry` with the given string.
     - parameter string: A string of the form MM/YYYY.
     */
    public convenience init?(string: String) {
        // Make sure that there is only one non-numeric separation character in the entire string
        guard string.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "0123456789")).characters.count == 1 else {
            return nil
        }
        
        let regex = try! NSRegularExpression(pattern: "^(\\d{1,2})[/|-](\\d{1,4})", options: .CaseInsensitive)
        var monthStr: String = ""
        var yearStr: String = ""
        
        guard let match = regex.firstMatchInString(string, options: .ReportProgress, range: NSMakeRange(0, string.characters.count)) else {
            return nil
        }
        
        let monthRange = match.rangeAtIndex(1)
        if monthRange.length > 0, let range = string.rangeFromNSRange(monthRange) {
            monthStr = string.substringWithRange(range)
        } else {
            return nil
        }
        
        let yearRange = match.rangeAtIndex(2)
        if yearRange.length > 0, let range = string.rangeFromNSRange(yearRange) {
            yearStr = string.substringWithRange(range)
        } else {
            return nil
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
    public convenience init?(month: String, var year: String) {
        if let numericYear = UInt(year) where numericYear < 100 {
            year = String(numericYear + Expiry.numberPrefix)
        }
        guard let monthVal = UInt(month) where monthVal > 0 && monthVal < 13 else {
            return nil
        }
        guard let yearVal = UInt(year) where yearVal >= Expiry.minYear && yearVal <= Expiry.maxYear else {
            return nil
        }
        
        self.init(month: monthVal, year: yearVal)
    }
    
    /**
     Returns the Card expiry date as human readable string with the format MM/YYYY
     */
    public func stringValue() -> String {
        return String(format: "%02i/%04i", arguments: [self.month, self.year])
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
