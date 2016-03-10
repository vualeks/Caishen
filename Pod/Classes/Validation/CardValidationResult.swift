//
//  CardValidationResult.swift
//  CardKit
//
//  Created by Daniel Vancura on 2/2/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/**
 A CardValidationResult is an `OptionSetType`. This means, it can be 
 combined with other CardValidationResult. This allows to have multiple 
 validation results in a single object, like having a card number that 
 does not match the card type and an expired card at the same time.
 
 **Example:**
 ````
 let result = CardValidationResult.NumberDoesNotMatchType.union(CardValidationResult.CardExpired)
*/
public struct CardValidationResult: OptionSetType {
    public let rawValue: UInt64
    
    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
    
    // MARK: - Default declarations
    public static let Valid                   = CardValidationResult(rawValue: 0)
    
    /** 
     Card number does not match the specified type or is too long.
     */
    public static let NumberDoesNotMatchType  = CardValidationResult(rawValue: 1 << 0)
    
    /**
     Card number does match the specified type but is too short.
     - note: This result will be returned for an incompleted card number.
     */
    public static let NumberIncomplete        = CardValidationResult(rawValue: 1 << 1)
    
    /**
     Invalid Card Verificaiton Code.
     */
    public static let InvalidCVC              = CardValidationResult(rawValue: 1 << 2)
    
    /**
     The Card Verification Code is too short.
     */
    public static let CVCIncomplete           = CardValidationResult(rawValue: 1 << 3)
    
    /**
     The card has already expired.
     */
    public static let CardExpired             = CardValidationResult(rawValue: 1 << 4)
    
    /**
     Card number does not match the specified type or is too long.
     */
    public static let NumberIsNotNumeric      = CardValidationResult(rawValue: 1 << 5)
    
    /**
     The Luhn test failed for the credit card number.
     - note: This result might be returned for an incompleted card number.
     */
    public static let LuhnTestFailed          = CardValidationResult(rawValue: 1 << 6)

    /// Indicates that the type of card could not be inferred.
    public static let UnknownType             = CardValidationResult(rawValue: 1 << 7)

}

extension CardValidationResult: CustomStringConvertible {

    public var description: String {
        if self == .Valid {
            return "Valid"
        } else {
            var resultString = "{\n"
            if isSupersetOf(.NumberDoesNotMatchType) {
                resultString += "\tNumber does not match type\n"
            }
            if isSupersetOf(.CVCIncomplete) {
                resultString += "\tCVC is too short\n"
            }
            if isSupersetOf(.InvalidCVC) {
                resultString += "\tCVC is invalid\n"
            }
            if isSupersetOf(.CardExpired) {
                resultString += "\tCard has expired\n"
            }
            if isSupersetOf(.NumberIsNotNumeric) {
                resultString += "\tCard number is not numeric\n"
            }
            if isSupersetOf(.LuhnTestFailed) {
                resultString += "\tLuhn test failed for card number\n"
            }
            if isSupersetOf(.NumberIncomplete) {
                resultString += "\tCard number seems to be incomplete\n"
            }
            if isSupersetOf(.UnknownType) {
                resultString += "\tCard type could not be inferred\n"
            }

            resultString += "}"

            return resultString
        }
    }

}
