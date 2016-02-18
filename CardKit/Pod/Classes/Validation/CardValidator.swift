//
//  CardValidator.swift
//  CardKit
//
//  Created by Daniel Vancura on 2/2/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public class CardValidator {
    private let expiryValidator: CardExpiryDateValidator
    public let cardTypeRegister: CardTypeRegister
    
    init(cardTypeRegister: CardTypeRegister) {
        expiryValidator = CardExpiryDateValidator()
        self.cardTypeRegister = cardTypeRegister
    }
    
    public func validateCard(card: Card) -> CardValidationResult {
        let numberValidationResult = cardTypeRegister.cardTypeForNumber(card.bankCardNumber)?.validateCardNumber(card.bankCardNumber)
        let cvcValidationResult = cardTypeRegister.cardTypeForNumber(card.bankCardNumber)?.validateCVC(card.cardVerificationCode.stringValue())
        
        return (numberValidationResult ?? .Valid)
            .union(cvcValidationResult ?? .Valid)
            .union(self.expiryValidator.validateExpiry(card.expiryDate))
    }
}
