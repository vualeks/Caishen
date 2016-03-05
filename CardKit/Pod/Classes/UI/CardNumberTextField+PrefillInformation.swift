//
//  CardNumberTextField+PrefillInformation.swift
//  Pods
//
//  Created by Daniel Vancura on 3/4/16.
//
//

import UIKit

public extension CardNumberTextField {
    
    public func prefillCardInformation(cardNumber: String?, month: Int?, year: Int?, cvc: String?) {
        if let year = year {
            var trimmedYear = year
            if year > 100 {
                trimmedYear = year % 100
            }
            
            if isYearValid(String(format: "%02i", arguments: [trimmedYear]), partiallyValid: true) {
                yearTextField?.text = String(trimmedYear)
                yearString = String(format: "%02i", arguments: [trimmedYear])
            }
        }
        
        if let month = month where isMonthValid(String(format: "%02i", arguments: [month]), partiallyValid: true) {
            monthTextField?.text = String(format: "%02i", arguments: [month])
            monthString = String(format: "%02i", arguments: [month])
        }
        
        if let cardNumber = cardNumber, let cardNumberInputTextField = cardNumberInputTextField {
            let validCharacters: Set<Character> = Set("0123456789".characters)
            let unformattedCardNumber = String(cardNumber.characters.filter({validCharacters.contains($0)}))
            
            let cardNumber = Number(rawValue: unformattedCardNumber)
            
            if cardTypeRegister.cardTypeForNumber(cardNumber)?.checkCardNumberPartiallyValid(cardNumber) == .Valid {
                let formatter = CardNumberFormatter(cardTypeRegister: cardTypeRegister)
                formatter.separator = cardNumberInputTextField.cardNumberSeparator
                cardNumberInputTextField.text = formatter.formattedCardNumber(unformattedCardNumber)
                cardNumberInputTextField.parsedCardNumber = cardNumber
                cardNumberTextFieldDidChangeText(cardNumberInputTextField)
            }
        }
        
        if let cvc = cvc where cardType?.validateCVC(CVC(rawValue: cvc)) == .Valid {
            cvcTextField?.text = cvc
            cardCVC = CVC(rawValue: cvc)
        }
        
        NSOperationQueue().addOperationWithBlock({
            NSThread.sleepForTimeInterval(0.5)
            NSOperationQueue.mainQueue().addOperationWithBlock({ [weak self] _ in
                self?.moveNumberFieldLeftAnimated()
            })
        })
        
        notifyDelegate()
    }
}
