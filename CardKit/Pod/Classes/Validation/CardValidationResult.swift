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
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    // MARK: - Default declarations
    public static let Valid                   = CardValidationResult(rawValue: 0)
    public static let NumberDoesNotMatchType  = CardValidationResult(rawValue: 1 << 0)
    public static let InvalidCVC              = CardValidationResult(rawValue: 1 << 1)
    public static let CardExpired             = CardValidationResult(rawValue: 1 << 2)
    public static let NumberIsNotNumeric      = CardValidationResult(rawValue: 1 << 3)
}