//
//  SPKCardType.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/23/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

/**
 A `CardType` is a predefined type for different bank cards. Bank card types can be determined by using a bank cards number with `CardType.ForNumber(bankCardNumber)`
 */
public enum CardType {
    case Amex
    case ChinaUnionPay
    case DinersClub
    case Discover
    case JCB
    case Maestro
    case MasterCard
    case Unknown
    case Visa
    
    public static func expectedLengthForCardType(cardType: CardType) -> Int {
        switch cardType {
        case .Amex:
            return 15
        case .DinersClub:
            return 14
        default:
            return 16
        }
    }
    
    public static func numberGroupingForCardType(cardType: CardType) -> [Int] {
        if cardType == .Amex {
            return [4,6,5]
        } else if cardType == .DinersClub {
            return [4,6,4]
        } else {
            return [4,4,4,4]
        }
    }
    
    /**
     Determines the card type for a specific bank card number.
     
     - parameter cardNumber: The card number, whose bank card type has to be determined.
     - returns: Card type for the given bank card number or `.Unknown`, if either the card number was too small or not valid for a specific bank.
     */
    public static func CardTypeForNumber(cardNumber: CardNumber) -> CardType {
        let cardNumberString = cardNumber.stringValue()
        
        if let digits = cardNumberString[0,6], numericFirstDigits = Int(digits) where numericFirstDigits >= 622126 && numericFirstDigits <= 622925 {
            return .Discover
        }
        // Check for JCB
        if let digits = cardNumberString[0,4], numericFirstDigits = Int(digits) where numericFirstDigits >= 3528 && numericFirstDigits <= 3589 || [3088, 3096, 3112, 3158, 3337].contains(numericFirstDigits) {
            return .JCB
        }
        // Check for Discover Card
        if let digits = cardNumberString[0,4] where ["6011"].contains(digits) {
            return .Discover
        }
        if let digits = cardNumberString[0,4] where ["2014","2149"].contains(digits) {
            return .DinersClub
        }
        // Check for Diners Club
        if let digits = cardNumberString[0,3] where ["300","301","302","303","304","305","309"].contains(digits) {
            return .DinersClub
        }
        if let digits = cardNumberString[0,3] where ["644","645","646","647","648","649"].contains(digits) {
            return .Discover
        }
        // Check for Amex
        if cardNumberString.hasPrefix("34") || cardNumberString.hasPrefix("37") {
            return .Amex
        }
        // Check for China UnionPay
        if cardNumberString.hasPrefix("62") {
            return .ChinaUnionPay
        }
        if let digits = cardNumberString[0,2] where ["36","38","39"].contains(digits) {
            return .DinersClub
        }
        // Check for Maestro
        if let digits = cardNumberString[0,2] where ["50","56","57","58","59"].contains(digits) {
            return .Maestro
        }
        // Check for MasterCard
        if let digits = cardNumberString[0,2] where ["51","52","53","54","55"].contains(digits) {
            return .MasterCard
        }
        // Check for Visa
        if cardNumberString[0,1] == "4" {
            return .Visa
        }
        
        return .Unknown
    }
}
