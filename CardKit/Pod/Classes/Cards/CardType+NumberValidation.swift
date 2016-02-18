//
//  CardType+NumberValidation.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import Foundation

public extension CardType {
    
    private func numberIsNumeric(number: CardNumber) -> CardValidationResult {
        for c in number.stringValue().characters {
            if !["0","1","2","3","4","5","6","7","8","9"].contains(c) {
                return CardValidationResult.NumberIsNotNumeric
            }
        }
        
        return CardValidationResult.Valid
    }
    
    public func numberIsValidLuhn(number: CardNumber) -> CardValidationResult {
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
            if digit > 9 {3
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
    
    private func lengthMatchesType(length: Int) -> CardValidationResult {
        return self.testLength(length, assumingLength: expectedCardNumberLength())
    }
    
    /**
     Returns Valid, if the card validation succeeded or the card validation failed because of the Luhn test or insufficient card number length, both of which are not important for incomplete card numbers.
     */
    public func checkCardNumberPartiallyValid(cardNumber: CardNumber) -> CardValidationResult {
        let validationResult = validateCardNumber(cardNumber)
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
        return lengthMatchesType(cardNumber.stringValue().length())
                .union(numberIsNumeric(cardNumber))
                .union(numberIsValidLuhn(cardNumber))
    }
}