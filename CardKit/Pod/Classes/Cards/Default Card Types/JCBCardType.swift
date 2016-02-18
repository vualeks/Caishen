//
//  JCBCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public class JCBCardType: NSObject, CardType {
    
    private var image: UIImage = UIImage(named: "JCB") ?? UIImage()
    
    public func cardTypeName() -> String {
        return "JCB"
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
        return Set(3528...3589).union( Set([3088, 3096, 3112, 3158, 3337]) )
    }
}