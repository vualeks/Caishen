//
//  AmexCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public struct AmericanExpress: CardType {
    
    public let cardTypeImage: UIImage? = UIImage(named: "Amex")
    
    public let cvcImage: UIImage? = UIImage(named: "AmexCVC") 
    
    public let name = "Amex"
    
    public let CVCLength = 4

    public let numberGrouping = [4, 6, 5]

    public let identifyingDigits = Set([34, 37])

    public init() {

    }

}
