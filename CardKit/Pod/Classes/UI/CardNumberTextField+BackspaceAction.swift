//
//  CardNumberTextField+BackspaceAction.swift
//  Pods
//
//  Created by Daniel Vancura on 3/4/16.
//
//

import UIKit

public extension CardNumberTextField {
    internal static var emptyTextFieldCharacter: String {
        return "\u{202F}"
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (textField.text?.characters.count ?? 0) == 0 {
            textField.text = CardNumberTextField.emptyTextFieldCharacter
        }
        
        return true
    }
    
    public override func shouldChangeTextInRange(range: UITextRange, replacementText text: String) -> Bool {
        
        
        return super.shouldChangeTextInRange(range, replacementText: text)
    }
}
