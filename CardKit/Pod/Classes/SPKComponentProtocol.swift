//
//  SPKComponentProtocol.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/19/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

protocol SPKComponentProtocol {
    func string() -> String?
    func isValid() -> Bool
    func isPartiallyValid() -> Bool
    func formattedString() -> String?
    func formattedStringWithTrail() -> String?
}

extension SPKComponentProtocol {
    func formattedString() -> String? {
        return string()
    }

    func formattedStringWithTrail() -> String? {
        return string()
    }
}
