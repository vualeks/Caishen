//
//  Card.swift
//  Caishen
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
     */
    public static func create(number: String, cardVerificationCode cvc: String, expiry: String) throws -> Card {
        // Create card number, cvc and expiry with the arguments provided
        let cardNumber = Number(rawValue: number)
        let cardCVC = CVC(rawValue: cvc)
        let cardExpiry = Expiry(string: expiry) ?? Expiry.invalid

        return Card(bankCardNumber: cardNumber, cardVerificationCode: cardCVC, expiryDate: cardExpiry)
    }

    /**
     Creates a `Card` with given card number, verification code and expiry date.
    */
    internal init(bankCardNumber: Number, cardVerificationCode: CVC, expiryDate: Expiry) {
        self.bankCardNumber = bankCardNumber
        self.cardVerificationCode = cardVerificationCode
        self.expiryDate = expiryDate
    }

}