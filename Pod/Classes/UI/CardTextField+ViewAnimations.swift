//
//  CardTextField+ViewAnimations.swift
//  Caishen
//
//  Created by Daniel Vancura on 3/9/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public extension CardTextField {
    // MARK: - View animations
    
    /**
     Moves the card number input field to the left outside of the screen with an animation of the duration `viewAnimationDuration`, so that only the last group of the card number is visible. At the same time, the card detail (expiration month and year and CVC) slide in from the right.
     */
    public func moveCardNumberOutAnimated() {
        UIView.animateWithDuration(viewAnimationDuration, animations: { [weak self] _ in
            self?.moveCardNumberOut()
            })
    }
    
    /**
     Moves the full card number input field to inside the screen with an animation of the duration `viewAnimationDuration`. At the same time, the card detail (expiration month and year and CVC) slide outside the view.
     */
    public func moveCardNumberInAnimated() {
        UIView.animateWithDuration(viewAnimationDuration, animations: { [weak self] _ in
            self?.moveCardNumberIn()
            })
    }
    
    /**
     Moves the card number input field to the left outside of the screen, so that only the last group of the card number is visible. At the same time, the card detail (expiration month and year and CVC) are displayed to its right.
     */
    public func moveCardNumberOut() {
        // If the card number is invalid, do not allow to move to the card detail
        if cardType?.validateNumber(card.bankCardNumber) != .Valid {
            return
        }
        numberInputTextField?.becomeFirstResponder()
        if let rect = numberInputTextField?.rectForLastGroup() {
            if isRightToLeftLanguage {
                let shapeLayer = CAShapeLayer()
                let path = CGPathCreateWithRect(rect, nil)
                shapeLayer.path = path
                numberInputTextField.layer.mask = shapeLayer
                numberInputTextField?.transform = CGAffineTransformIdentity
            } else {
                numberInputTextField?.transform =
                    CGAffineTransformMakeTranslation(-rect.origin.x, 0)
            }
        } else {
            numberInputTextField?.alpha = 0
        }
        numberInputTextField?.resignFirstResponder()
        cardInfoView?.transform = CGAffineTransformIdentity
        monthTextField.becomeFirstResponder()
    }
    
    /**
     Moves the full card number input field to inside the screen. At the same time, the card detail (expiration month and year and CVC) are moved outside the view.
     */
    public func moveCardNumberIn() {
        let infoTextFields: [UITextField?] = [monthTextField, yearTextField, cvcTextField]
        infoTextFields.forEach({$0?.resignFirstResponder()})
        numberInputTextField?.transform = CGAffineTransformIdentity
        numberInputTextField?.alpha = 1
        numberInputTextField.becomeFirstResponder()
        numberInputTextField.layer.mask = nil
        let offset = isRightToLeftLanguage ? -superview!.bounds.width : superview!.bounds.width
        cardInfoView?.transform = CGAffineTransformMakeTranslation(offset, 0)
    }
}