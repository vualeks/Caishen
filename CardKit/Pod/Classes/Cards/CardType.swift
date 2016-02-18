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



@objc
public protocol CardType {
    
    func cardTypeName() -> String
    
    func expectedCardNumberLength() -> Int
    
    func expectedCVCLength() -> Int
    
    func cardNumberGrouping() -> [Int]
    
    func cardTypeImage() -> UIImage
    
    func overrideImageForCardType(image: UIImage)
    
    func checkCardNumberAgainstCardType(cardNumber: CardNumber) -> Bool
}
