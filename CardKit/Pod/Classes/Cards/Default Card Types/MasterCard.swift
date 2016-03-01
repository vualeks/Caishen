//
//  MasterCardCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

public struct MasterCard: CardType {
    
    public let cardTypeImage: UIImage? = UIImage(named: "MasterCard")
    
    public let name = "MasterCard"

    public let CVCLength = 3

    public let identifyingDigits = Set(51...55)

    public init() {
        
    }

}