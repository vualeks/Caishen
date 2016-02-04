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
        guard let _ = UInt(number.stringValue()) else {
            return CardValidationResult.NumberIsNotNumeric
        }
        
        return CardValidationResult.Valid
    }
    
    private func numberIsValidLuhn(number: CardNumber) -> CardValidationResult {
        var odd = true
        var sum = 0
        let digits = NSMutableArray(capacity: number.stringValue().length())
        for i in 0..<number.stringValue().length() {
            digits.addObject(NSString(string: number.stringValue()[i,i+1]))
        }
        for obj in digits.reverseObjectEnumerator() {
            let digitString = obj as! NSString
            var digit = digitString.integerValue
            odd = !odd
            if odd {
                digit = digit * 2
            }
            if digit > 9 {
                digit = digit - 9
            }
            sum += digit
        }
        
        if sum % 10 == 0 {
            return CardValidationResult.Valid
        } else {
            return CardValidationResult.LuhnTestFailed
        }
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
