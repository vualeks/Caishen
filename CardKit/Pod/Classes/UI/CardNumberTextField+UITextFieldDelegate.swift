//
//  CardNumberTextField+UITextFieldDelegate.swift
//  Pods
//
//  Created by Daniel Vancura on 3/4/16.
//
//

import UIKit

public extension CardNumberTextField {

    public func textFieldDidBeginEditing(textField: UITextField) {
        if textField == cardNumberInputTextField {
            moveNumberFieldRightAnimated()
        }
        
        if textField == monthTextField {
            textField.textAlignment = .Right
        }
        
        if textField == cvcTextField {
            cardImageView?.image = cardType?.cvcImage ?? unknownCardTypeImage
        } else {
            cardImageView?.image = cardType?.cardTypeImage ?? unknownCardTypeImage
        }
    }
    
    public final func textFieldDidChange(textField: UITextField) {
        switch textField {
        case let val where val == cvcTextField:
            if isCVCValid(textField.text ?? "", partiallyValid: false) {
                cardCVC = CVC(rawValue: textField.text!)
            } else {
                cardCVC = nil
            }
        case let val where val == monthTextField:
            if isMonthValid(textField.text ?? "", partiallyValid: false) {
                monthString = textField.text!
                yearTextField?.becomeFirstResponder()
            } else {
                monthString = nil
            }
        case let val where val == yearTextField:
            if isYearValid(textField.text ?? "", partiallyValid: false) {
                yearString = textField.text!
                cvcTextField?.becomeFirstResponder()
            } else {
                yearString = nil
            }
        default:
            break
        }
        
        notifyDelegate()
    }
    
    public final func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // For text fields other than the card number text field (which implements input validation on its own), validate the input
        
        var updatedRange = range
        if text == CardNumberTextField.emptyTextFieldCharacter {
            updatedRange.location -= 1
        }
        
        let newValue = NSString(string: textField.text ?? "").stringByReplacingCharactersInRange(updatedRange, withString: string).stringByReplacingOccurrencesOfString(CardNumberTextField.emptyTextFieldCharacter, withString: "")
        switch textField {
        case let val where val == cvcTextField:
            if isCVCValid(newValue, partiallyValid: true) {
                textField.text = newValue
                textFieldDidChange(textField)
            }
            return false
        case let val where val == monthTextField:
            if isMonthValid(newValue, partiallyValid: true) {
                textField.text = newValue
                textFieldDidChange(textField)
            }
            return false
        case let val where val == yearTextField:
            if isYearValid(newValue, partiallyValid: true) {
                textField.text = newValue
                textFieldDidChange(textField)
            }
            return false
        default:
            return true
        }
    }
}
