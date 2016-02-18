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
    
    public func checkCardNumberAgainstCardType(cardNumber: CardNumber) -> Bool {
        if let number = Int(cardNumber.stringValue()[0,4] ?? "") where number >= 3528 && number <= 3589 || [3088, 3096, 3112, 3158, 3337].contains(number) {
            return true
        }
        return false
    }
}