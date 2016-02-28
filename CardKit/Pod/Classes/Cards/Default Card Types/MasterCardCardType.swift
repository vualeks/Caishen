//
//  MasterCardCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

public struct MasterCardCardType: CardType {
    
    public static var cardTypeImage: UIImage? = UIImage(named: "MasterCard") ?? UIImage()
    public static var cvcImage: UIImage? = UIImage(named: "CVC") ?? UIImage()
    
    public static func cardTypeName() -> String {
        return "MasterCard"
    }
    
    public static func expectedCVCLength() -> Int {
        return 3
    }
    
    public static func cardNumberGrouping() -> [Int] {
        return [4,4,4,4]
    }
    
    public static func cardDigitsIdentifyingCardType() -> Set<Int> {
        return Set(51...55)
    }
}