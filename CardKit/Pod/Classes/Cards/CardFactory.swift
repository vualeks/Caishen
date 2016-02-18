//
//  CardFactory.swift
//  Pods
//
//  Created by Daniel Vancura on 2/3/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public enum CardFactoryCreationException: ErrorType {
    case InvalidDateFormat
    case CardValidationFailed(validationResult: CardValidationResult)
}

public class CardFactory: NSObject {
    /**
     Factory method to create a card from string arguments as provided by a UITextField.
     - parameter number: The string value of the card number.
     - parameter cvc: The string value of the card verification code.
     - parameter expiry: the string value of the expiry date (example: 09/2018)
     - throws: `CardFactoryCreationException.InvalidDateFormat` if the date format provided for `expiry` could not be parsed
     - throws: `CardFactoryCreationException.CardValidationFailed` if the card validation failed.
    */
    public class func createCardWithNumber(number: String, cardVerificationCode cvc: String, expiry: String, cardTypeRegister: CardTypeRegister?) throws -> Card {
        // Create card number, cvc and expiry with the arguments provided
        let cardNumber = CardNumber(string: number)
        let cardCVC = CardCVC(string: cvc)
        guard let cardExpiry = CardExpiry(string: expiry) else {
            // Throw an exception if the date format didn't match
            throw CardFactoryCreationException.InvalidDateFormat
        }
        
        // Create a card with the given arguments
        let card = Card(bankCardNumber: cardNumber, cardVerificationCode: cardCVC, expiryDate: cardExpiry)
        let cardValidator = CardValidator(cardTypeRegister: cardTypeRegister ?? CardTypeRegister.sharedCardTypeRegister)
        
        // Validate the card. If invalid, throw an exception with details about the validation result.
        let validationResult = cardValidator.validateCard(card)
        guard validationResult == CardValidationResult.Valid else {
            throw CardFactoryCreationException.CardValidationFailed(validationResult: validationResult)
        }
        
        return card
    }
}
