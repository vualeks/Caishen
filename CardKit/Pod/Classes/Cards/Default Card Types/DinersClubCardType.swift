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
    
    public func checkCardNumberAgainstCardType(cardNumber: CardNumber) -> Bool {
        if let val2 = cardNumber.stringValue()[0,2], let val3 = cardNumber.stringValue()[0,3], let val4 = cardNumber.stringValue()[0,4] where
            ["300","301","302","303","304","305","309"].contains(val3) && val4 != "3096"
                || ["2014","2149"].contains(val4)
                || ["36","38","39"].contains(val2) {
            return true
        }
        return false
    }
}