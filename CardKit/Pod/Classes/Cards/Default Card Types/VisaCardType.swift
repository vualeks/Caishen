//
//  VisaCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public struct VisaCardType: CardType {
    
    public static var cardTypeImage: UIImage? = UIImage(named: "Visa") ?? UIImage(named: "Visa", inBundle: NSBundle(forClass: CardTypeRegister.self), compatibleWithTraitCollection: nil)
    public static var cvcImage: UIImage? = UIImage(named: "CVC") ?? UIImage(named: "CVC", inBundle: NSBundle(forClass: CardTypeRegister.self), compatibleWithTraitCollection: nil)
    
    public static func cardTypeName() -> String {
        return "Visa"
    }
    
    public static func expectedCVCLength() -> Int {
        return 3
    }
    
    public static func cardNumberGrouping() -> [Int] {
        return [4,4,4,4]
    }
    
    public static func cardDigitsIdentifyingCardType() -> Set<Int> {
        return Set([4])
    }
}
