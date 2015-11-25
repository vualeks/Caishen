//
//  SPKCard.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/25/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

class SPKCard {
    var number: String?
    var cvc: String?
    var expMonth: Int?
    var expYear: Int?

    func last4() -> String? {
        if let number = number {
            if number.length() >= 4 {
                //We need to return last 4
                let index = number.endIndex.advancedBy(-4)
                return number.substringFromIndex(index)
            }
        }
        return nil
    }
}