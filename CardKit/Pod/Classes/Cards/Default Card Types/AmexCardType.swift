//
//  AmexCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public struct AmexCardType: CardType {
    
    private static var image: UIImage = UIImage(named: "Amex") ?? UIImage()
    private static var cvcIm: UIImage = UIImage(named: "AmexCVC") ?? UIImage()
    
    public static func cardTypeName() -> String {
        return "Amex"
    }
    
    public static func expectedCVCLength() -> Int {
        return 4
    }
    
    public static func cardNumberGrouping() -> [Int] {
        return [4,6,5]
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
        return Set([34,37])
    }
}
