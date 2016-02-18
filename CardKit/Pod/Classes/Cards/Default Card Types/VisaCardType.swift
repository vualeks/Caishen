//
//  VisaCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public class VisaCardType: NSObject, CardType {
    
    private var image: UIImage = UIImage(named: "Visa") ?? UIImage()
    
    public func cardTypeName() -> String {
        return "Visa"
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
        return Set([4])
    }
}
