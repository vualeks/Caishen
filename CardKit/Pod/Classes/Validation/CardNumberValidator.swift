//
//  CardNumberValidator.swift
//  CardKit
//
//  Created by Daniel Vancura on 2/2/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public class CardNumberValidator: NSObject {
    
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
            // If the number is not long enough, fail the Luhn test
            guard let digit = number.stringValue()[i,i+1] else {
                return CardValidationResult.LuhnTestFailed
            }
            digits.addObject(NSString(string: digit))
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
    
    /**
     Helper method for `lengthMatchesType` to check the actual length of a card number against the expected length.
     - parameter actualLength: The length of a card number that is to be validated.
     - parameter expectedLength: The expected length for the card number's card type.
     - returns: CardValidationResult.Valid if the lengths match, CardValidationResult.NumberDoesNotMatchType otherwise.
     */
    private func testLength(actualLength: Int, assumingLength expectedLength: Int) -> CardValidationResult {
        if actualLength == expectedLength {
            return CardValidationResult.Valid
        } else if actualLength < expectedLength {
            return CardValidationResult.NumberIncomplete
        } else {
            return CardValidationResult.NumberDoesNotMatchType
        }
    }
    
    private func lengthMatchesType(length: Int, type: CardType) -> CardValidationResult {
        return self.testLength(length, assumingLength: CardType.expectedLengthForCardType(type))
    }
    
    /**
     Returns Valid, if the card validation succeeded or the card validation failed because of the Luhn test or insufficient card number length, both of which are not important for incomplete card numbers.
     */
    public func checkCardNumberPartiallyValid(cardNumber: CardNumber) -> CardValidationResult {
        let validationResult = self.validateCardNumber(cardNumber)
        let completeNumberButLuhnTestFailed = !validationResult.isSupersetOf(CardValidationResult.NumberIncomplete) && validationResult.isSupersetOf(CardValidationResult.LuhnTestFailed)
        
        if completeNumberButLuhnTestFailed {
            return validationResult
        } else {
            return
                self.validateCardNumber(cardNumber)
                    .subtract(CardValidationResult.NumberIncomplete)
                    .subtract(CardValidationResult.LuhnTestFailed)
        }
    }
    
    public func validateCardNumber(cardNumber: CardNumber) -> CardValidationResult {
        let cardType = CardType.CardTypeForNumber(cardNumber)
        
        return
            self.lengthMatchesType(cardNumber.stringValue().length(), type: cardType)
                .union(self.numberIsNumeric(cardNumber))
                .union(self.numberIsValidLuhn(cardNumber))
    }
}
