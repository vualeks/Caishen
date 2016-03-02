//
//  MasterCardCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public struct MasterCard: CardType {
    
    public let cardTypeImage: UIImage? = UIImage(named: "MasterCard") ?? UIImage(named: "MasterCard", inBundle: NSBundle(forClass: CardNumberTextField.self), compatibleWithTraitCollection: nil)
    
    public let name = "MasterCard"

    public let CVCLength = 3

    public let identifyingDigits = Set(51...55)

    public init() {
        
    }

}