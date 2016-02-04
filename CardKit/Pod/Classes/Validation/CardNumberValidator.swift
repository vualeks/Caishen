//
//  CardNumberValidator.swift
//  CardKit
//
//  Created by Daniel Vancura on 2/2/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public class CardNumberValidator {
    
    private func numberIsNumeric(number: CardNumber) -> CardValidationResult {
        guard let number = UInt(number.stringValue()) else {
            return CardValidationResult.NumberIsNotNumeric
        }
        
        return CardValidationResult.Valid
    }
    
    private func lengthMatchesType(length: Int, type: CardType) -> CardValidationResult {
        switch type {
        case .CardTypeAmex:
            if length == 4 {
                return CardValidationResult.Valid
            } else {
                return CardValidationResult.NumberDoesNotMatchType
            }
        default:
            if length == 3 {
                return CardValidationResult.Valid
            } else {
                return CardValidationResult.NumberDoesNotMatchType
            }
        }
    }
    
    public func validateCardNumber(cardNumber: CardNumber, forCardType cardType: CardType) -> CardValidationResult {
        return
            self.lengthMatchesType(cardNumber.stringValue().length(), type: cardType)
            .union(self.numberIsNumeric(cardNumber))
    }
}
