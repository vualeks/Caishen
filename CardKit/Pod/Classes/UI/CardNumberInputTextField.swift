//
//  FormattedCardNumberTextField.swift
//  Pods
//
//  Created by Daniel Vancura on 2/9/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

@objc
public protocol CardNumberInputTextFieldDelegate {
    /**
     Called by `cardNumberTextField` when the user changed the text in the card number text field..
     
     - parameter cardNumberTextField: The CardNumberTextField that was used by the user to change a card number.
     - parameter text: The text that is currently entered in `self`
     */
    optional func cardNumberInputTextField(cardNumberTextField: CardNumberInputTextField, didChangeText text: String)
    
    /**
     Called by `cardNumberTextField` when the user entered a valid card number.
     
     - parameter cardNumberTextField: The CardNumberTextField that was used by the user to enter a card number.
     - parameter cardNumber: The card number the user entered.
     */
    optional func cardNumberInputTextField(cardNumberTextField: CardNumberInputTextField, didEnterValidCardNumber cardNumber: CardNumber)
}

@IBDesignable
public class CardNumberInputTextField: StylizedTextField {
    
    public private(set) var parsedCardNumber: CardNumber?
    @IBOutlet public var cardNumberInputTextFieldDelegate: CardNumberInputTextFieldDelegate?
    @IBInspectable public var invalidInputColor: UIColor = UIColor.redColor()
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
    private var cardTypeRegister: CardTypeRegister = CardTypeRegister.sharedCardTypeRegister
    private var cardType: CardType.Type?
    private var cardNumberFormatter: CardNumberFormatter {
        get {
            return CardNumberFormatter(separator: self.cardNumberSeparator, cardTypeRegister: cardTypeRegister)
        }
    }
    
    private struct SaveOldColor {
        static var onceToken: dispatch_once_t = 0
        static var oldTextColor: UIColor?
        
        init(textColor: UIColor?) {
            dispatch_once(&SaveOldColor.onceToken, {
                SaveOldColor.oldTextColor = textColor
            })
        }
    }
    
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
    
    public override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = NSString(string: textField.text ?? "")
        
        let newText = cardNumberFormatter.unformattedCardNumber(textFieldText.stringByReplacingCharactersInRange(range, withString: string))
        
        let newTextIsNumeric = UInt(newText) != nil
        
        // Create a card number with the newly formed string.
        parsedCardNumber = CardNumber(string: newText)
        
        if let parsedCardNumber = parsedCardNumber {
            let partialValidation = cardTypeRegister.cardTypeForNumber(parsedCardNumber)?.checkCardNumberPartiallyValid(parsedCardNumber)
            let completeValidation = cardTypeRegister.cardTypeForNumber(parsedCardNumber)?.validateCardNumber(parsedCardNumber)
            
            if completeValidation == nil && partialValidation == nil && newText.length() <= 6 {
                userEnteredPartiallyValidCardNumber(parsedCardNumber)
                cardNumberFormatter.replaceRangeFormatted(range, inTextField: textField, withString: string)
                
                cardNumberInputTextFieldDelegate?.cardNumberInputTextField?(self, didChangeText: newText)
                
                return false
            } else if completeValidation == CardValidationResult.Valid {
                userDidEnterValidCardNumber(parsedCardNumber)
                cardNumberFormatter.replaceRangeFormatted(range, inTextField: textField, withString: string)
                
                cardNumberInputTextFieldDelegate?.cardNumberInputTextField?(self, didEnterValidCardNumber: CardNumber(string: self.cardNumberFormatter.unformattedCardNumber(newText)))
                
                return false
            } else if partialValidation == CardValidationResult.Valid {
                userEnteredPartiallyValidCardNumber(parsedCardNumber)
                cardNumberFormatter.replaceRangeFormatted(range, inTextField: textField, withString: string)
                
                cardNumberInputTextFieldDelegate?.cardNumberInputTextField?(self, didChangeText: newText)
                
                return false
            } else {
                flashTextFieldInvalid()
                
                return false
            }
        }
        
        return newTextIsNumeric
    }
    
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
    
    private func userDidEnterValidCardNumber(number: CardNumber) {
        self.cardType = cardTypeRegister.cardTypeForNumber(number)
    }
    
    private func userEnteredPartiallyValidCardNumber(number: CardNumber) {
        self.cardType = cardTypeRegister.cardTypeForNumber(number)
    }
}
