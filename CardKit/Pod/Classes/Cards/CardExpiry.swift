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
private var dateFormatter: NSDateFormatter = {
    var formatter = NSDateFormatter()
    formatter.dateFormat = "MM/yyyy"
    return formatter
}()

public class CardExpiry {
    private let month: UInt
    private let year: UInt
    
    /**
     Creates a `CardExpiry` with the given string.
     - parameter string: A string of the form MM/YYYY.
     */
    public convenience init?(string: String) {
        // This should already provide a valid date, which means that no additional checks for invalid months or years are provided:
        guard let stringAsDate = dateFormatter.dateFromString(string) else {
            return nil
        }
        
        let month = UInt(NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.component(.Month, fromDate: stringAsDate))
        let year = UInt(NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.component(.Year, fromDate: stringAsDate))
        
        self.init(month: month, year: year)
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
        let monthVal = UInt(NSString(string: month).integerValue)
        let yearVal = UInt(NSString(string: year).integerValue)
        guard monthVal > 0 && monthVal < 13 else {
            return nil
        }
        guard yearVal > 1000 else {
            return nil
        }
        
        self.init(month: monthVal, year: yearVal)
    }
    
    /**
     Returns the Card expiry date as human readable string with the format MM/YYYY
     */
    public func stringValue() -> String {
        return String(format: "%2i/%4i", arguments: [self.month, self.year])
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
