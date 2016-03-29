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
public class DetailInputTextField: StylizedTextField, AutoCompletingTextField, TextFieldValidation {
    
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
        
        let autoCompletedNewText = autocompleteText(newText)
        
        if autoCompletedNewText.characters.count > expectedInputLength {
            let index = autoCompletedNewText.startIndex.advancedBy(expectedInputLength)
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

extension DetailInputTextField: AutoCompletingTextField {

    func autocompleteText(text: String) -> String {
        return text
    }
}
}
