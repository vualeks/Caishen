//
//  MasterCardCardType.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

public struct MasterCardCardType: CardType {
    
    private static var image: UIImage = UIImage(named: "MasterCard") ?? UIImage()
    private static var cvcIm: UIImage = UIImage(named: "CVC") ?? UIImage()
    
    public static func cardTypeName() -> String {
        return "MasterCard"
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
    
    public static func cvcImage() -> UIImage {
        return cvcIm
    }
    
    public static func overrideCVCImage(image: UIImage) {
        cvcIm = image
    }
    
    public static func cardDigitsIdentifyingCardType() -> Set<Int> {
        return Set(51...55)
    }
}