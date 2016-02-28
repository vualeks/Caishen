//
//  DinersClubCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public struct DinersClubCardType: CardType {
    
    public static var cardTypeImage: UIImage? = UIImage(named: "DinersClub") ?? UIImage()
    public static var cvcImage: UIImage? = UIImage(named: "CVC") ?? UIImage()
    
    public static func cardTypeName() -> String {
        return "Diners Club"
    }
    
    public static func expectedCVCLength() -> Int {
        return 3
    }
    
    public static func cardNumberGrouping() -> [Int] {
        return [4,6,4]
    }
    
    public static func cardDigitsIdentifyingCardType() -> Set<Int> {
        return Set(300...305).union( Set([36, 38, 39, 309, 2014, 2149]) )
    }
}