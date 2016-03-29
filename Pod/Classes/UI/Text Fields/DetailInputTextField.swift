//
//  DetailInputTextField.swift
//  Caishen
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
    
    // Default number of expected digits for MonthInputTextField and YearInputTextField
    var expectedDigits: Int {
        return 2
    }

    var cardInfoTextFieldDelegate: CardInfoTextFieldDelegate?
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text ?? "").isEmpty {
            textField.text = UITextField.emptyTextFieldCharacter
        }
    }
    
    public override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: (textField.text ?? "")).stringByReplacingCharactersInRange(range, withString: string).stringByReplacingOccurrencesOfString(UITextField.emptyTextFieldCharacter, withString: "")
        
        let deletingLastCharacter = !(textField.text ?? "").isEmpty && textField.text != UITextField.emptyTextFieldCharacter && newText.isEmpty
        if deletingLastCharacter {
            textField.text = UITextField.emptyTextFieldCharacter
            cardInfoTextFieldDelegate?.textField(self, didEnterPartiallyValidInfo: newText)
            return false
        }
        
        let autoCompletedNewText = autoCompletedText(newText)
        
        if autoCompletedNewText.characters.count > expectedDigits {
            let index = autoCompletedNewText.startIndex.advancedBy(expectedDigits)
            cardInfoTextFieldDelegate?.textField(self, didEnterOverflowInfo: autoCompletedNewText.substringFromIndex(index))
        }
        if isInputValid(autoCompletedNewText, partiallyValid: false) {
            textField.text = autoCompletedNewText
            cardInfoTextFieldDelegate?.textField(self, didEnterValidInfo: autoCompletedNewText)
        } else if isInputValid(autoCompletedNewText, partiallyValid: true) {
            textField.text = autoCompletedNewText
            cardInfoTextFieldDelegate?.textField(self, didEnterPartiallyValidInfo: autoCompletedNewText)
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

    /**
     Returns the auto-completed text for the new text
     E.g. if user input a "4" in a monthInputTextField, it should show a string of "04" instead.
     This makes the input process easier for users

     - returns: Auto-completed string.
     */
    internal func autoCompletedText(text: String) -> String {
        return text
    }
}
