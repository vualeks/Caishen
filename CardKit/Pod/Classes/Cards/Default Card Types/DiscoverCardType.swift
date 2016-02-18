//
//  DiscoverCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public class DiscoverCardType: NSObject, CardType {
    private var image: UIImage = UIImage(named: "Discover") ?? UIImage()
    
    public func cardTypeName() -> String {
        return "Discover"
    }
    
    public func expectedCVCLength() -> Int {
        return 3
    }
    
    public func expectedCardNumberLength() -> Int {
        return 16
    }
    
    public func cardNumberGrouping() -> [Int] {
        return [4,4,4,4]
    }
    
    public func cardTypeImage() -> UIImage {
        return image
    }
    
    public func overrideImageForCardType(image: UIImage) {
        self.image = image
    }
    
    public func cardDigitsIdentifyingCardType() -> Set<Int> {
        return Set(644...649).union( Set(622126...622925) ).union( Set([6011]) )
    }
}
