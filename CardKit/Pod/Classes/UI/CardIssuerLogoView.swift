//
//  CardIssuerLogoView.swift
//  Pods
//
//  Created by Daniel Vancura on 2/9/16.
//
//

import UIKit

public class CardIssuerLogoView: UIImageView {
    private func imageForCardType(cardType: CardType) -> UIImage? {
        let imageName: String
        switch cardType {
        case .Amex:
            imageName = "Amex"
        case .DinersClub:
            imageName = "Diners"
        case .Discover:
            imageName = "Discover"
        case .JCB:
            imageName = "JCB"
        case .MasterCard:
            imageName = "MasterCard"
        case .Visa:
            imageName = "Visa"
        default:
            imageName = "Unknown"
        }
        
        return UIImage(named: imageName)
    }
    
    public func displayLogoForCardType(cardType: CardType) {
        self.image = self.imageForCardType(cardType)
    }
}
