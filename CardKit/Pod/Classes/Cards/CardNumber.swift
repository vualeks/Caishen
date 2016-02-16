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
    
    public func last4() -> String? {
        if number.length() >= 4 {
            return number.substringFromIndex(number.endIndex.advancedBy(-4))
        }
        return nil
    }
    
    /**
     - returns: The last group of the card number. In case of an Amex card, this are 5 digits. For other cards, this are the last 4 digits.
     */
    public func lastGroup() -> String? {
        switch CardType.CardTypeForNumber(self) {
        case .Amex:
            if number.length() >= 5 {
                return number.substringFromIndex(number.endIndex.advancedBy(-5))
            }
        default:
            return self.last4()
        }
        return nil
    }
    
    public func stringValue() -> String {
        return self.number
    }
}