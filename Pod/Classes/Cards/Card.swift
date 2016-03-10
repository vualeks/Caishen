//
//  Card.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/25/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

/**
 A card represents a physical bank card with all its associated attributes.
*/
public struct Card {

    public let bankCardNumber: Number
    public let cardVerificationCode: CVC
    public let expiryDate: Expiry

    /**
     Factory method to create a card from string arguments as provided by a UITextField.
     - parameter number: The string value of the card number.
     - parameter cvc: The string value of the card verification code.
     - parameter expiry: the string value of the expiry date (example: 09/2018)
     - throws: `CardCreationError.InvalidDateFormat` if the date format provided for `expiry` could not be parsed
     - throws: `CardCreationError.CardValidationFailed` if the card validation failed.
     */
    public static func create(number: String, cardVerificationCode cvc: String, expiry: String, cardTypeRegister: CardTypeRegister = .sharedCardTypeRegister) throws -> Card {
        // Create card number, cvc and expiry with the arguments provided
        let cardNumber = Number(rawValue: number)
        let cardCVC = CVC(rawValue: cvc)
        guard let cardExpiry = Expiry(string: expiry) else {
            // Throw an exception if the date format didn't match
            throw CardCreationError.InvalidDateFormat
        }

        // Create a card with the given arguments
        let card = Card(bankCardNumber: cardNumber, cardVerificationCode: cardCVC, expiryDate: cardExpiry)
        let cardValidator = CardValidator(cardTypeRegister: cardTypeRegister)

        // Validate the card. If invalid, throw an exception with details about the validation result.
        let validationResult = cardValidator.validateCard(card)
        guard validationResult == CardValidationResult.Valid else {
            throw CardCreationError.CardValidationFailed(validationResult: validationResult)
        }

        return card
    }

    /**
     Creates a `Card` with given card number, verification code and expiry date.
    */
    internal init(bankCardNumber: Number, cardVerificationCode: CVC, expiryDate: Expiry) {
        self.bankCardNumber = bankCardNumber
        self.cardVerificationCode = cardVerificationCode
        self.expiryDate = expiryDate
    }

    /**
     - returns: True if the card has been validated successfully.
    */
    public func isValid(cardTypeRegister: CardTypeRegister) -> Bool {
        return CardValidator(cardTypeRegister: cardTypeRegister).validateCard(self) == CardValidationResult.Valid
    }
}