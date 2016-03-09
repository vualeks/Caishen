//
//  Number.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/25/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

public struct Number: RawRepresentable {

    public typealias RawValue = String

    public let rawValue: String

    public var length: Int {
        return rawValue.characters.count
    }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

}

extension Number: CustomStringConvertible {

    public var description: String {
        return rawValue
    }

}