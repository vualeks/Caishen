//
//  SPKCardNumber.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/25/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

public class CardNumber: NSObject {
    private var number: String
    
    public init(string: String) {
        self.number = string
    }
    
    public func stringValue() -> String {
        return self.number
    }
    
    public func validate(cardTypeRegister: CardTypeRegister) -> CardValidationResult {
        return (cardTypeRegister.cardTypeForNumber(self) ?? VisaCardType.self).validateCardNumber(self)
    }
}