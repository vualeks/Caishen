//
//  CardNumberTextField+UITextFieldDelegate.swift
//  Caishen
//
//  Created by Daniel Vancura on 3/4/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

extension CardTextField: CardInfoTextFieldDelegate {

    public func textField(textField: UITextField, didEnterValidInfo: String) {
        checkCardExpired()
        selectNextTextField(textField)
    }
    
    public func textField(textField: UITextField, didEnterPartiallyValidInfo: String) {
        checkCardExpired()
    }
    
    private func selectNextTextField(textField: UITextField) {
        if textField == monthTextField {
            yearTextField?.becomeFirstResponder()
        } else if textField == yearTextField {
            cvcTextField?.becomeFirstResponder()
        }
    }
    
    private func checkCardExpired() {
        // if the date is invalid, set the text color for the date to `invalidNumberColor`
        if card.expiryDate.rawValue.timeIntervalSinceNow < 0 {
            monthTextField?.textColor = invalidInputColor ?? UIColor.redColor()
            yearTextField?.textColor = invalidInputColor ?? UIColor.redColor()
        } else {
            monthTextField?.textColor = numberInputTextField?.textColor ?? UIColor.blackColor()
            yearTextField?.textColor = numberInputTextField?.textColor ?? UIColor.blackColor()
        }
        
        notifyDelegate()
    }
}
