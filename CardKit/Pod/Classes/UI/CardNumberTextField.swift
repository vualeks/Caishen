//
//  CardNumberTextField.swift
//  Pods
//
//  Created by Daniel Vancura on 2/9/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

@objc
public protocol CardNumberTextFieldDelegate {
    optional func cardNumberTextField(cardNumberTextField: CardNumberTextField, didChangeText text: String)
    optional func cardNumberTextField(cardNumberTextField: CardNumberTextField, didEnterValidCardNumber cardNumber: CardNumber)
}

@IBDesignable
public class CardNumberTextField: StylizedTextField {
    
    public private(set) var parsedCardNumber: CardNumber?
    public var cardNumberTextFieldDelegate: CardNumberTextFieldDelegate?
    
    @IBInspectable
    public var invalidInputColor: UIColor = UIColor.redColor()
    
    private var validInputColor: UIColor?
    
    @IBInspectable
    public var cardNumberSeparator: String = "-" {
        didSet {
            self.placeholder = self.cardNumberFormatter.formattedCardNumber(self.placeholder ?? "1234123412341234")
        }
    }
    
    override public var placeholder: String? {
        didSet {
            guard let placeholder = placeholder else {
                return
            }
            let isUnformatted = (placeholder == self.cardNumberFormatter.unformattedCardNumber(placeholder))
            
            // Format the placeholder, if not already done
            if isUnformatted && self.cardNumberSeparator != "" {
                self.placeholder = self.cardNumberFormatter.formattedCardNumber(placeholder)
            } else {
                return
            }
        }
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
    
    public func rectForLastGroup() -> CGRect? {
        guard let lastGroupLength = text?.componentsSeparatedByString(cardNumberFormatter.separator).last?.length() else {
            return nil
        }
        guard let textLength = text?.length() else {
            return nil
        }
        
        return rectForTextRange(NSMakeRange(textLength - lastGroupLength, lastGroupLength), inTextField: self)
    }
    
    private var cardType: CardType = .Unknown
    
    private var cardNumberFormatter: CardNumberFormatter {
        get {
            return CardNumberFormatter(separator: self.cardNumberSeparator)
        }
    }
    
    private func userDidEnterValidCardNumber(number: CardNumber) {
        self.cardType = CardType.CardTypeForNumber(number)
    }
    
    private func userEnteredPartiallyValidCardNumber(number: CardNumber) {
        self.cardType = CardType.CardTypeForNumber(number)
    }
    
    override func postInit() {
        super.postInit()
        self.validInputColor = self.textColor
    }
    
    public override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = NSString(string: textField.text ?? "")
        
        let newText = cardNumberFormatter.unformattedCardNumber(textFieldText.stringByReplacingCharactersInRange(range, withString: string))
        
        let newTextIsNumeric = UInt(newText) != nil
        
        if newText.length() == 0 {
            self.cardType = .Unknown
            return true
        }
        
        // Create a card number with the newly formed string.
        self.parsedCardNumber = CardNumber(string: newText)
        let cardNumberValidator = CardNumberValidator()
        
        if let parsedCardNumber = parsedCardNumber {
            let partialValidation = cardNumberValidator.checkCardNumberPartiallyValid(parsedCardNumber)
            let completeValidation = cardNumberValidator.validateCardNumber(parsedCardNumber)
            
            if completeValidation == CardValidationResult.Valid {
                self.userDidEnterValidCardNumber(parsedCardNumber)
                self.cardNumberFormatter.replaceRangeFormatted(range, inTextField: textField, withString: string)
                self.textColor = self.validInputColor
                
                self.cardNumberTextFieldDelegate?.cardNumberTextField?(self, didEnterValidCardNumber: CardNumber(string: self.cardNumberFormatter.unformattedCardNumber(newText)))
                
                return false
            } else if partialValidation == CardValidationResult.Valid {
                self.userEnteredPartiallyValidCardNumber(parsedCardNumber)
                self.textColor = self.validInputColor
                self.cardNumberFormatter.replaceRangeFormatted(range, inTextField: textField, withString: string)
                
                self.cardNumberTextFieldDelegate?.cardNumberTextField?(self, didChangeText: newText)
                
                return false
            } else {
                self.textColor = self.invalidInputColor
                
                return false
            }
        }
        
        return newTextIsNumeric
    }
}
