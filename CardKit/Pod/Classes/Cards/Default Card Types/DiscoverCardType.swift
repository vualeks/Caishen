//
//  DiscoverCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public struct DiscoverCardType: CardType {
    
    public static var cardTypeImage: UIImage? = UIImage(named: "Discover") ?? UIImage()
    public static var cvcImage: UIImage? = UIImage(named: "CVC") ?? UIImage()
    
    public static func cardTypeName() -> String {
        return "Discover"
    }
    
    public static func expectedCVCLength() -> Int {
        return 3
    }
    
    public static func cardNumberGrouping() -> [Int] {
        return [4,4,4,4]
    }
    
    public static func cardDigitsIdentifyingCardType() -> Set<Int> {
        return Set(644...649).union( Set(622126...622925) ).union( Set([6011]) )
    }
}
