//
//  CardType+CVCValidation.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import Foundation

public extension CardType {
    
    public func validateCVC(cvc: CardCVC) -> CardValidationResult {
        return validateCVC(cvc.stringValue())
    }
    
    public func validateCVC(cvc: String) -> CardValidationResult {
        if cvc.length() > expectedCVCLength() || Int(cvc) == nil {
            return CardValidationResult.InvalidCVC
        } else if cvc.length() < expectedCVCLength() {
            return CardValidationResult.CVCIncomplete
        } else {
            return CardValidationResult.Valid
        }
    }
}