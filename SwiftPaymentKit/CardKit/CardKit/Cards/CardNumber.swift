//
//  SPKCardNumber.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/25/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

public class CardNumber {
    internal var number: String
    
    public init?(string: String) {
        //Strip non-digits from the CVC string passed in
        number = string.stringByReplacingOccurrencesOfString("\\D", withString: "",
            options: .RegularExpressionSearch, range: string.startIndex..<string.endIndex)
        if number.length() < 3 || number.length() > 4 {
            return nil
        }
    }
    
    internal func last4() -> String {
        if number.length() >= 4 {
            return number.substringFromIndex(number.endIndex.advancedBy(-4))
        }
        return ""
    }
    
    public func lastGroup() -> String? {
        switch CardType.CardTypeForNumber(self) {
        case .CardTypeAmex:
            if number.length() >= 5 {
                return number.substringFromIndex(number.endIndex.advancedBy(-5))
            }
        default:
            return self.last4()
        }
        return nil
    }
}