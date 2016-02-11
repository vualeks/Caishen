//
//  CardCVCValidator.swift
//  CardKit
//
//  Created by Daniel Vancura on 2/3/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public class CardCVCValidator: NSObject {
    public func validateCVC(cvc: CardCVC, forCardType cardType: CardType) -> CardValidationResult {
        return self.checkCVCLength(cvc, forCardType: cardType)
            .union(self.checkCVCNumeric(cvc))
    }
    
    /**
     Tests whether or not the card's CVC has the right number of digits.
     - parameter cvc: The card's cvc.
     - parameter cardType: The bank card's card type.
     - returns: InvalidCVC, if the length of the CVC does not match the card type. Valid otherwise.
    */
    private func checkCVCLength(cvc: CardCVC, forCardType cardType: CardType) -> CardValidationResult {
        switch cardType {
        case .Amex:
            // Expect the cvc of an Amex card to be 4 digits long.
            if cvc.length() < 4 {
                return CardValidationResult.CVCIncomplete
            } else if cvc.length() == 4 {
                return CardValidationResult.Valid
            } else {
                return CardValidationResult.InvalidCVC
            }
        default:
            // Expect the cvc of other cards to be 3 digits long.
            if cvc.length() < 3 {
                return CardValidationResult.CVCIncomplete
            } else if cvc.length() == 3 {
                return CardValidationResult.Valid
            } else {
                return CardValidationResult.InvalidCVC
            }
        }
    }
    
    /**
     Checks if the CVC only contains numbers
    */
    private func checkCVCNumeric(cvc: CardCVC) -> CardValidationResult {
        if let _ = Int(cvc.stringValue()) {
            return CardValidationResult.Valid
        } else {
            return CardValidationResult.InvalidCVC
        }
    }
}
