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
    
    /**
     - returns: The card type name (e.g.: Visa, MasterCard, ...)
     */
    static func cardTypeName() -> String
    
    /**
     - returns: The number of digits expected in the Card Validation Code.
     */
    static func expectedCVCLength() -> Int
    
    /**
     The card number grouping is used to format the card number when typing in the card number text field.
     For Visa Card types for example, this grouping would be [4,4,4,4], resulting in a card number format like
     0000-0000-0000-0000.
     - returns: The grouping of digits in the card number.
     */
    static func cardNumberGrouping() -> [Int]
    
    /**
     - returns: The card type image, that is displayed in a card number text field's image view to indicate the detected card type for the user.
     */
    static func cardTypeImage() -> UIImage
    
    /**
     Use this function to override the default image for a card type.
     
     - parameter image: The image used to indicate the card type for the user.
     */
    static func overrideImageForCardType(image: UIImage)
    
    /**
     - returns: The card validation code image, that is displayed in a card number text field's image view to show the number the user has to enter.
     */
    static func cvcImage() -> UIImage
    
    /**
     Use this function to override the default image for a card validation code.
     
     - parameter image: The image used to indicate the cvc for the user.
     */
    static func overrideCVCImage(image: UIImage)
    
    /**
     Card types are typically identified by their first n digits. In compliance to ISO/IEC 7812, the first digit is the *Major industry identifier*, which is equal to:
        - 1, 2 for airlines
        - 3 for Travel & Entertainment (non-banks like American Express, DinersClub, ...)
        - 4, 5 for banking and financial institutions
        - 6 for merchandising and banking/financial (Discover Card, Laser, China UnionPay, ...)
        - 7 for petroleum and other future industry assignments
        - 8 for healthcare, telecommunications and other future industry assignments
        - 9 for assignment by national standards bodies
     The first 6 digits also are the *Issuer Identification Number*, indicating the issuer of the card. 
     
     In order to identify the card issuer, this function returns a Set of integers which indicate the card issuer. In case of Discover for example, this is the set of [(644...649),(622126...622925),(6011)], which contains different IIN ranges which are reserved for Discover.
     
     - returns: A set of numbers which, when being found in the first digits of the card number, indicate the card issuer.
     */
    static func cardDigitsIdentifyingCardType() -> Set<Int>
}
