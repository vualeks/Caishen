//
//  CardNumberTextField+ViewAnimations.swift
//  Pods
//
//  Created by Daniel Vancura on 3/9/16.
//
//

import UIKit

public extension CardNumberTextField {
    // MARK: - View animations
    
    internal func moveNumberFieldLeftAnimated() {
        UIView.animateWithDuration(viewAnimationDuration ?? 0.3, animations: { [weak self] _ in
            self?.moveNumberFieldLeft()
            })
    }
    
    internal func moveNumberFieldRightAnimated() {
        UIView.animateWithDuration(viewAnimationDuration ?? 0.3, animations: { [weak self] _ in
            self?.moveNumberFieldRight()
            })
    }
    
    /**
     Translates the card number text field outside the screen.
     */
    internal func moveNumberFieldLeft() {
        // Only when the card number has been set, the user can swipe to the details
        if cardNumber == nil {
            return
        }
        
        numberInputTextField?.becomeFirstResponder()
        if let rect = numberInputTextField?.rectForLastGroup() {
            numberInputTextField?.transform =
                CGAffineTransformMakeTranslation(-rect.origin.x, 0)
        } else {
            numberInputTextField?.alpha = 0
        }
        numberInputTextField?.resignFirstResponder()
        cardInfoView?.transform = CGAffineTransformIdentity
    }
    
    /**
     Moves the card number text field to its original position.
     */
    internal func moveNumberFieldRight() {
        let infoTextFields: [UITextField?] = [monthTextField, yearTextField, cvcTextField]
        infoTextFields.forEach({$0?.resignFirstResponder()})
        numberInputTextField?.transform = CGAffineTransformIdentity
        numberInputTextField?.alpha = 1
        cardInfoView?.transform = CGAffineTransformMakeTranslation(superview!.bounds.width, 0)
    }
}