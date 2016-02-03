//
//  SPKCardType.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/23/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

/**
 A `CardType` is a predefined type for different bank cards. Bank card types can be determined by using a bank cards number with `CardType.CardTypeForNumber(bankCardNumber)`
 */
public enum CardType {
    case CardTypeAmex
    case CardTypeDinersClub
    case CardTypeDiscover
    case CardTypeJCB
    case CardTypeMasterCard
    case CardTypeUnknown
    case CardTypeVisa
    
    /**
     Determines the card type for a specific bank card number.
     
     - parameter cardNumber: The card number, whose bank card type has to be determined.
     - returns: Card type for the given bank card number or `.CardTypeUnknown`, if either the card number was too small or not valid for a specific bank.
     */
    public static func CardTypeForNumber(cardNumber: CardNumber) -> CardType {
        guard cardNumber.number.length() >= 2 else {
            return .CardTypeUnknown
        }
        
        let firstTwoDigits = NSString(string: cardNumber.number[0,2]).integerValue
        
        switch firstTwoDigits {
        case 30, 36, 38, 39:
            return .CardTypeDinersClub
        case 34, 37:
            return .CardTypeAmex
        case 35:
            return .CardTypeJCB
        case 40...49:
            return .CardTypeVisa
        case 50...59:
            return .CardTypeMasterCard
        case 60, 62, 64, 65:
            return .CardTypeDiscover
        default:
            return .CardTypeUnknown
        }
    }
}
