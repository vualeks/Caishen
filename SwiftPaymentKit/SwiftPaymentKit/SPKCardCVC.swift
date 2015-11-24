//
//  SPKCardNumber.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/23/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

class SPKCardCVC: SPKComponentProtocol {
    private var cvc: String = ""

    init(string: String?) {
        if let string = string {
            //Strip non-digits from the CVC string passed in
            let nonNumericSet = NSCharacterSet.decimalDigitCharacterSet().invertedSet
            cvc = string.componentsSeparatedByCharactersInSet(nonNumericSet).joinWithSeparator("")
        }
    }

    func string() -> String? {
        return cvc
    }

    func isPartiallyValid() -> Bool {
        return cvc.length() <= 4
    }

    func isValid() -> Bool {
        return cvc.length() >= 3 && cvc.length() <= 4
    }

    func isValidWithType(cardType: SPKCardType) -> Bool {
        switch cardType {
        case .SPKCardTypeAmex:
            return cvc.length() == 4
        default:
            return cvc.length() == 3
        }
    }

    func isPartiallyValidWithType(cardType: SPKCardType) -> Bool {
        switch cardType {
        case .SPKCardTypeAmex:
            return cvc.length() <= 4
        default:
            return cvc.length() <= 3
        }
    }
}
