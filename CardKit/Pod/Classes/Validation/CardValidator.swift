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
        guard let cardType = cardTypeRegister.cardTypeForNumber(card.bankCardNumber) else {
            return .UnknownType
        }

        let numberValidationResult = cardType.validateNumber(card.bankCardNumber)
        let cvcValidationResult = cardType.validateCVC(card.cardVerificationCode)
        
        return numberValidationResult
            .union(cvcValidationResult)
            .union(expiryValidator.validateExpiry(card.expiryDate))
    }
}
