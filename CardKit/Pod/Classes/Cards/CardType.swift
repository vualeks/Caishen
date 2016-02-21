//
//  SPKCardType.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/23/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

/**
 A `CardType` is a predefined type for different bank cards. Bank card types can be determined by using a bank cards number with `CardType.ForNumber(bankCardNumber)`
 */
public protocol CardType {
    
    static func cardTypeName() -> String
    
    static func expectedCVCLength() -> Int
    
    static func cardNumberGrouping() -> [Int]
    
    static func cardTypeImage() -> UIImage
    
    static func overrideImageForCardType(image: UIImage)
    
    static func cardDigitsIdentifyingCardType() -> Set<Int>
}
