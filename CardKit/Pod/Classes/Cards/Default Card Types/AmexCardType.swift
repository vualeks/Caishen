//
//  AmexCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public struct AmexCardType: CardType {
    
    public static var cardTypeImage: UIImage? = UIImage(named: "Amex") ?? UIImage(named: "Amex", inBundle: NSBundle(forClass: CardTypeRegister.self), compatibleWithTraitCollection: nil)
    public static var cvcImage: UIImage? = UIImage(named: "AmexCVC") ?? UIImage(named: "AmexCVC", inBundle: NSBundle(forClass: CardTypeRegister.self), compatibleWithTraitCollection: nil)
    
    public static func cardTypeName() -> String {
        return "Amex"
    }
    
    public static func expectedCVCLength() -> Int {
        return 4
    }
    
    public static func cardNumberGrouping() -> [Int] {
        return [4,6,5]
    }
    
    public static func cardDigitsIdentifyingCardType() -> Set<Int> {
        return Set([34,37])
    }
}
