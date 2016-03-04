//
//  CardNumberTextField+ValidityChecks.swift
//  Pods
//
//  Created by Daniel Vancura on 3/4/16.
//
//

import UIKit

internal extension CardNumberTextField {

    /**
     Checks the validity of the entered card validation code.
     
     - returns: True, if the card validation code is valid.
     */
    internal func isCVCValid(cvcString: String, partiallyValid: Bool) -> Bool {
        if cvcString.characters.count == 0 && partiallyValid {
            return true
        }
        
        let cvc = CVC(rawValue: cvcString)
        return (cardType?.validateCVC(cvc) == .Valid) ?? false || partiallyValid && (cardType?.validateCVC(cvc) == .CVCIncomplete) ?? false
    }
    
    /**
     Checks the validity of the entered month.
     
     - returns: True, if the month is valid.
     */
    internal func isMonthValid(month: String, partiallyValid: Bool) -> Bool {
        let length = month.characters.count
        if partiallyValid && length == 0 {
            return true
        }
        
        guard let monthInt = UInt(month) else {
            return false
        }
        
        if length == 1 && !["0","1"].contains(month) {
            return false
        }
        
        return ((monthInt >= 1 && monthInt <= 12) ||
            (partiallyValid && month == "0")) &&
            (partiallyValid || length == 2)
    }
    
    /**
     Checks the validity of the entered year.
     
     - returns: True, if the year is valid.
     */
    internal func isYearValid(year: String, partiallyValid: Bool) -> Bool {
        if partiallyValid && year.characters.count == 0 {
            return true
        }
        
        guard let yearInt = UInt(year) else {
            return false
        }
        
        return yearInt >= 0 &&
            yearInt < 100 &&
            (partiallyValid || year.characters.count == 2)
    }
}
