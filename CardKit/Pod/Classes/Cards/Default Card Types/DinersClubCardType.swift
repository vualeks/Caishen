//
//  DinersClubCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public struct DinersClubCardType: CardType {
    
    private static var image: UIImage = UIImage(named: "DinersClub") ?? UIImage()
    private static var cvcIm: UIImage = UIImage(named: "CVC") ?? UIImage()
    
    public static func cardTypeName() -> String {
        return "Diners Club"
    }
    
    public static func expectedCVCLength() -> Int {
        return 3
    }
    
    public static func cardNumberGrouping() -> [Int] {
        return [4,6,4]
    }
    
    public static func cardTypeImage() -> UIImage {
        return image
    }
    
    public static func overrideImageForCardType(image: UIImage) {
        self.image = image
    }
    
    public static func cvcImage() -> UIImage {
        return cvcIm
    }
    
    public static func overrideCVCImage(image: UIImage) {
        cvcIm = image
    }
    
    public static func cardDigitsIdentifyingCardType() -> Set<Int> {
        return Set(300...305).union( Set([36, 38, 39, 309, 2014, 2149]) )
    }
}