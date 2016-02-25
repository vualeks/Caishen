//
//  FormattedCardNumberTextField.swift
//  Pods
//
//  Created by Daniel Vancura on 2/9/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/**
 This kind of text field only allows entering card numbers and provides means to customize the appearance of entered card numbers by changing the card number group separator.
 */
@IBDesignable
public class CardNumberInputTextField: StylizedTextField {
    
    // MARK: - Variables
    
    /**
     The card number that has been entered into this text field. 
     
     - note: This card number may be incomplete and invalid while the user is entering a card number.
     */
    public private(set) var parsedCardNumber: CardNumber?
    
    /**
     */
    @IBOutlet public var cardNumberInputTextFieldDelegate: CardNumberInputTextFieldDelegate?
    
    /**
     The color in which text flashes, when the user is about to enter an invalid card number.
     */
    @IBInspectable public var invalidInputColor: UIColor = UIColor.redColor()
    
    /**
     The string that is used to separate different groups in a card number.
     */
    @IBInspectable public var cardNumberSeparator: String = "-" {
        didSet {
        placeholder = cardNumberFormatter.formattedCardNumber(self.placeholder ?? "1234123412341234")
        }
    }
    override public var placeholder: String? {
        didSet {
        guard let placeholder = placeholder else {
            return
        }
        let isUnformatted = (placeholder == self.cardNumberFormatter.unformattedCardNumber(placeholder))
        
        // Format the placeholder, if not already done
        if isUnformatted && cardNumberSeparator != "" {
            self.placeholder = cardNumberFormatter.formattedCardNumber(placeholder)
        } else {
            return
        }
        }
    }
    
    /**
     The card type register that holds information about which card types are accepted and which ones are not.
     */
    private var cardTypeRegister: CardTypeRegister = CardTypeRegister.sharedCardTypeRegister
    
    /**
     The currently detected card type for the entered card number. May be nil, if no card type has been detected.
     */
    private var cardType: CardType.Type?
    
    /**
     A card number formatter used to format the input
     */
    private var cardNumberFormatter: CardNumberFormatter {
        get {
            return CardNumberFormatter(separator: self.cardNumberSeparator, cardTypeRegister: cardTypeRegister)
        }
    }
    
    /**
     Private struct for storing the text color when flashing the text field.
     Using asynchronous operations to flash the text field would result in the text color being overwritten:
     - user types in invalid number
        -> Original text color is stored
        -> Text color is set to red for 0.5 seconds
     - after less than 0.5 seconds, the user types in invalid card number again
        -> The text color is stored again, but right now, this text color is red.
     
     Solution: Save the text color only on first read.
     */
    private struct SaveOldColor {
        static var onceToken: dispatch_once_t = 0
        static var oldTextColor: UIColor?
        
        init(textColor: UIColor?) {
            dispatch_once(&SaveOldColor.onceToken, {
                SaveOldColor.oldTextColor = textColor
            })
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    public override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = NSString(string: textField.text ?? "")
        let newText = cardNumberFormatter.unformattedCardNumber(textFieldText.stringByReplacingCharactersInRange(range, withString: string))
        let newTextIsNumeric = UInt(newText) != nil
        
        // Create a card number with the newly formed string.
        parsedCardNumber = CardNumber(string: newText)
        
        if let parsedCardNumber = parsedCardNumber {
            let partialValidation = cardTypeRegister.cardTypeForNumber(parsedCardNumber)?.checkCardNumberPartiallyValid(parsedCardNumber)
            let completeValidation = cardTypeRegister.cardTypeForNumber(parsedCardNumber)?.validateCardNumber(parsedCardNumber)
            
            // Based on the validity of the input, allow changing the input or forbid (resulting in the text color changing shortly)
            if completeValidation == nil && partialValidation == nil && newText.length() <= 6 {
                // Case 1: No card type has been detected so far and less or equal than 6 digits have been entered (the amount of digits in a IIN for identification of the card issuer)
                cardType = cardTypeRegister.cardTypeForNumber(parsedCardNumber)
                cardNumberFormatter.replaceRangeFormatted(range, inTextField: textField, withString: string)
                cardNumberInputTextFieldDelegate?.cardNumberInputTextField?(self, didChangeText: newText)
                
                return false
            } else if completeValidation == CardValidationResult.Valid {
                // Case 2: A card type has been detected and the card number was entered completely
                cardType = cardTypeRegister.cardTypeForNumber(parsedCardNumber)
                cardNumberFormatter.replaceRangeFormatted(range, inTextField: textField, withString: string)
                cardNumberInputTextFieldDelegate?.cardNumberInputTextField?(self, didEnterValidCardNumber: CardNumber(string: self.cardNumberFormatter.unformattedCardNumber(newText)))
                
                return false
            } else if partialValidation == CardValidationResult.Valid {
                // Case 3: A card type has been detected, but the card number is only partially valid
                cardType = cardTypeRegister.cardTypeForNumber(parsedCardNumber)
                cardNumberFormatter.replaceRangeFormatted(range, inTextField: textField, withString: string)
                cardNumberInputTextFieldDelegate?.cardNumberInputTextField?(self, didChangeText: newText)
                
                return false
            } else {
                // Case 4: The user was about to change the card number so that it would become invalid
                flashTextFieldInvalid()
                
                return false
            }
        }
        
        return newTextIsNumeric
    }
    
    // MARK: - Helper functions
    
    /**
     Computes the rect that contains the specified text range within the text field.
     
     - parameter range: The range of the text in the text field whose bounds should be detected.
     - parameter textField: The text field containing the text.
     - returns: A rect indicating the location and bounds of the text within the text field, or nil, if an invalid range has been entered.
     */
    private func rectForTextRange(range: NSRange, inTextField textField: UITextField) -> CGRect? {
        guard let rangeStart = textField.positionFromPosition(textField.beginningOfDocument, offset: range.location) else {
            return nil
        }
        guard let rangeEnd = textField.positionFromPosition(rangeStart, offset: range.length) else {
            return nil
        }
        guard let textRange = textField.textRangeFromPosition(rangeStart, toPosition: rangeEnd) else {
            return nil
        }
        
        return textField.firstRectForRange(textRange)
    }
    
    /**
     - returns: The CGRect in `self` that contains the last group of the card number.
     */
    public func rectForLastGroup() -> CGRect? {
        guard let lastGroupLength = text?.componentsSeparatedByString(cardNumberFormatter.separator).last?.length() else {
            return nil
        }
        guard let textLength = text?.length() else {
            return nil
        }
        
        return rectForTextRange(NSMakeRange(textLength - lastGroupLength, lastGroupLength), inTextField: self)
    }
    
    /**
     Shortly changes the text color to indicate, that the user was about to enter an invalid card number.
     */
    private func flashTextFieldInvalid() {
        NSOperationQueue().addOperationWithBlock({ [unowned self] _ in
            SaveOldColor(textColor: self.textColor)
            dispatch_async(dispatch_get_main_queue(), {
                UIView.animateWithDuration(0.5, animations: { [unowned self] _ in
                    self.textColor = self.invalidInputColor
                    })
            })
            NSThread.sleepForTimeInterval(0.5)
            dispatch_async(dispatch_get_main_queue(), {
                UIView.animateWithDuration(0.5, animations: { [unowned self] _ in
                    self.textColor = SaveOldColor.oldTextColor
                    })
            })
            })
    }
}
