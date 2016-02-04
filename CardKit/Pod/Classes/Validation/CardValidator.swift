//
//  CardValidator.swift
//  CardKit
//
//  Created by Daniel Vancura on 2/2/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public class CardValidator {
    private let numberValidator: CardNumberValidator
    private let cvcValidator: CardCVCValidator
    private let expiryValidator: CardExpiryDateValidator
    
    init() {
        self.numberValidator = CardNumberValidator()
        self.cvcValidator = CardCVCValidator()
        self.expiryValidator = CardExpiryDateValidator()
    }
    
    public func validateCard(card: Card) -> CardValidationResult {
        return
            self.numberValidator.validateCardNumber(card.bankCardNumber, forCardType: card.type)
            .union(self.cvcValidator.validateCVC(card.cardVerificationCode, forCardType: card.type))
            .union(self.expiryValidator.validateExpiry(card.expiryDate))
    }
}
