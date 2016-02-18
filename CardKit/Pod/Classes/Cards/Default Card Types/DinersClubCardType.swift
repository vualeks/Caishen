//
//  DinersClubCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

public class DinersClubCardType: NSObject, CardType {
    private var image: UIImage = UIImage(named: "DinersClub") ?? UIImage()
    
    public func cardTypeName() -> String {
        return "Diners Club"
    }
    
    public func expectedCVCLength() -> Int {
        return 3
    }
    
    public func expectedCardNumberLength() -> Int {
        return 14
    }
    
    public func cardNumberGrouping() -> [Int] {
        return [4,6,4]
    }
    
    public func cardTypeImage() -> UIImage {
        return image
    }
    
    public func overrideImageForCardType(image: UIImage) {
        self.image = image
    }
    
    public func cardDigitsIdentifyingCardType() -> Set<Int> {
        return Set(300...305).union( Set([36, 38, 39, 309, 2014, 2149]) )
    }
}