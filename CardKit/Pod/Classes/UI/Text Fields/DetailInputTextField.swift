//
//  DetailInputTextField.swift
//  Pods
//
//  Created by Daniel Vancura on 3/9/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/**
 A text field subclass that validates any input for card detail before changing the text attribute.
 You can subclass `DetailInputTextField` and override `isInputValid` to specify the validation routine.
 The default implementation accepts any input.
 */
public class DetailInputTextField: StylizedTextField {
    
    var cardInfoTextFieldDelegate: CardInfoTextFieldDelegate?
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text ?? "").isEmpty {
            textField.text = CardNumberTextField.emptyTextFieldCharacter
        }
    }
    
    public override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: (textField.text ?? "")).stringByReplacingCharactersInRange(range, withString: string).stringByReplacingOccurrencesOfString(CardNumberTextField.emptyTextFieldCharacter, withString: "")
        
        let deletingLastCharacter = !(textField.text ?? "").isEmpty && textField.text != CardNumberTextField.emptyTextFieldCharacter && newText.isEmpty
        if deletingLastCharacter {
            textField.text = CardNumberTextField.emptyTextFieldCharacter
            cardInfoTextFieldDelegate?.textField(self, didEnterPartiallyValidInfo: newText)
            return false
        }
        
        if isInputValid(newText, partiallyValid: false) {
            textField.text = newText
            cardInfoTextFieldDelegate?.textField(self, didEnterValidInfo: newText)
        } else if isInputValid(newText, partiallyValid: true) {
            textField.text = newText
            cardInfoTextFieldDelegate?.textField(self, didEnterPartiallyValidInfo: newText)
        }
        
        return false
    }
    
    public func prefillInformation(info: String) {
        if isInputValid(info, partiallyValid: false) {
            text = info
            cardInfoTextFieldDelegate?.textField(self, didEnterValidInfo: info)
        } else if isInputValid(info, partiallyValid: true) {
            text = info
            cardInfoTextFieldDelegate?.textField(self, didEnterPartiallyValidInfo: info)
        }
    }
    
    /**
     Checks the validity of the input.
     
     - returns: True, if the input is valid.
     */
    internal func isInputValid(input: String, partiallyValid: Bool) -> Bool {
        return true
    }
}
