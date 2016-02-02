//
//  SPKCardNumber.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/25/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

class SPKCardNumber: SPKComponentProtocol {
    var cardType: SPKCardType = .SPKCardTypeUnknown

    private var number: String? {
        didSet {
            guard let number = number where number.length() > 2 else {
                cardType = .SPKCardTypeUnknown
                return
            }

            if let range = number.rangeFromNSRange(NSMakeRange(0, 2)) {
                let firstChars = number.substringWithRange(range)
                if let intRange = Int(firstChars) {
                    switch intRange {
                    case 30, 36, 38, 39:
                        cardType = .SPKCardTypeDinersClub
                    case 34, 37:
                        cardType = .SPKCardTypeAmex
                    case 35:
                        cardType = .SPKCardTypeJCB
                    case 40...49:
                        cardType = .SPKCardTypeVisa
                    case 50...59:
                        cardType = .SPKCardTypeMasterCard
                    case 60, 62, 64, 65:
                        cardType = .SPKCardTypeDiscover
                    default:
                        cardType = .SPKCardTypeUnknown
                    }
                }
            }
        }
    }

    init(string: String?) {
        if let string = string {
            //Strip non-digits from the CVC string passed in
            number = string.stringByReplacingOccurrencesOfString("\\D", withString: "",
                options: .RegularExpressionSearch, range: string.startIndex..<string.endIndex)
        }
        cardType = .SPKCardTypeUnknown
    }

    func string() -> String? {
        return number
    }

    func formattedString() -> String? {
        return nil
    }

    func formattedStringWithTrail() -> String? {
        return nil
    }

    func last4() -> String? {
        if let number = number {
            if number.length() >= 4 {
                return number.substringFromIndex(number.endIndex.advancedBy(-4))
            }
        }
        return nil
    }

    func lastGroup() -> String? {
        if let number = number {
            switch cardType {
            case .SPKCardTypeAmex:
                if number.length() >= 5 {
                    return number.substringFromIndex(number.endIndex.advancedBy(-5))
                }
            default:
                if number.length() >= 4 {
                    return number.substringFromIndex(number.endIndex.advancedBy(-4))
                }
            }
        }
        return nil
    }

    func isValid() -> Bool {
        return false
    }

    func isValidLength() -> Bool {
        return false
    }

    func isValidLuhn() -> Bool {
        return false
    }

    func isPartiallyValid() -> Bool {
        return false
    }


}