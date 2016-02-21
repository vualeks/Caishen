//
//  DiscoverCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public struct DiscoverCardType: CardType {
    
    private static var image: UIImage = UIImage(named: "Discover") ?? UIImage()
    
    public static func cardTypeName() -> String {
        return "Discover"
    }
    
    public static func expectedCVCLength() -> Int {
        return 3
    }
    
    public static func cardNumberGrouping() -> [Int] {
        return [4,4,4,4]
    }
    
    public static func cardTypeImage() -> UIImage {
        return image
    }
    
    public static func overrideImageForCardType(image: UIImage) {
        self.image = image
    }
    
    public static func cardDigitsIdentifyingCardType() -> Set<Int> {
        return Set(644...649).union( Set(622126...622925) ).union( Set([6011]) )
    }
}
