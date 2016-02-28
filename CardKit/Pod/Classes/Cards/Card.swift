//
//  SPKCard.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/25/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

/**
 A card represents a physical bank card with all its associated attributes.
*/
public class Card: NSObject {
    public let bankCardNumber: CardNumber
    public let cardVerificationCode: CardCVC
    public let expiryDate: CardExpiry
    
    /**
     Creates a `Card` with given card number, verification code and expiry date.
    */
    internal init(bankCardNumber: CardNumber, cardVerificationCode: CardCVC, expiryDate: CardExpiry) {
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