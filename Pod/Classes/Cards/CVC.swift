//
//  CVC.swift
//  Caishen
//
//  Created by Sagar Natekar on 11/23/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

public struct CVC: RawRepresentable {

    public typealias RawValue = String

    public var length: Int {
        return rawValue.characters.count
    }

    public let rawValue: String

    /**
     Creates a new bank card verification code with the given argument.
     
     - parameter string: The string representation of the CVC.
    */
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public func toInt() -> Int? {
        return Int(rawValue)
    }

}

extension CVC: CustomStringConvertible {

    public var description: String {
        return rawValue
    }

}
