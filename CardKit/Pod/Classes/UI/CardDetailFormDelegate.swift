//
//  CardDetailFormDelegate.swift
//  Pods
//
//  Created by Daniel Vancura on 2/10/16.
//
//

import UIKit

public protocol CardDetailFormDelegate {
    func cardDetailFormDidFinish(form: CardDetailForm, withCVC cvc: CardCVC, withExpiry expiry: CardExpiry)
    func cardDetailFormShouldDismiss()
}