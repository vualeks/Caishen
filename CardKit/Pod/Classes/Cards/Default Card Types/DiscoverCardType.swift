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
    
    public func checkCardNumberAgainstCardType(cardNumber: CardNumber) -> Bool {
        if let val4 = cardNumber.stringValue()[0,4], let val3 = cardNumber.stringValue()[0,3] where
            "6001" == val4
                || ["300","301","302","303","304","305","309","644","645","646","647","648","649"].contains(val3) {
            return true
        } else if let number = Int(cardNumber.stringValue()[0,6] ?? "") where number >= 622126 && number <= 622925 {
            return true
        }
        return false
    }
}
