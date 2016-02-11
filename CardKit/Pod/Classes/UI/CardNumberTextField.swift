//
//  CardNumberTextField.swift
//  Pods
//
//  Created by Daniel Vancura on 2/9/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

@IBDesignable
public class CardNumberTextField: StylizedTextField, CardDetailFormDelegate {
    
    private var parsedCardNumber: CardNumber?
    
    /**
     The view that shows the credit card's logo when a card type has been detected.
     */
    public var logoView: CardIssuerLogoView? {
        set {
            self.leftView = newValue
        }
        get {
            return self.leftView as? CardIssuerLogoView
        }
    }
    
    /**
     The view that is used to enter detail for a bank card.
     This form lets the user enter the card's CVC and expiry.
     */
    public var cardDetailForm: CardDetailForm? {
        set {
            self.rightView = newValue
        }
        get {
            return self.rightView as? CardDetailForm
        }
    }
    
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
    
    private var cardType: CardType = .Unknown {
        willSet {
            if cardType != newValue {
                (self.leftView as? CardIssuerLogoView)?.displayLogoForCardType(newValue)
            }
        }
    }
    
    private var cardNumberFormatter: CardNumberFormatter {
        get {
            return CardNumberFormatter(separator: self.cardNumberSeparator)
        }
    }
    
    private func userDidEnterValidCardNumber(number: CardNumber) {
        self.cardType = CardType.CardTypeForNumber(number)
        
        self.cardDetailForm = NSBundle(forClass: CardDetailForm.self).loadNibNamed("CardDetailForm", owner: self, options: nil).first as? CardDetailForm
        
        self.cardDetailForm?.delegate = self
        
        self.animateOpenDetail()
    }
    
    private func userEnteredPartiallyValidCardNumber(number: CardNumber) {
        self.cardType = CardType.CardTypeForNumber(number)
    }
    
    override func postInit() {
        super.postInit()
        self.leftView = CardIssuerLogoView()
        (self.leftView as? CardIssuerLogoView)?.displayLogoForCardType(.Unknown)
        self.leftView?.contentMode = .ScaleAspectFit
        self.leftView?.clipsToBounds = true
    }
    
    private func setTextAndCursorPositionForTextField(textField: UITextField, newText: String) {
        let cursorPositionAfterChanges = cardNumberFormatter.cursorPositionAfterFormattingText(self.cardNumberFormatter.unformattedCardNumber(newText), inTextField: textField)!
        
        textField.text = cardNumberFormatter.formattedCardNumber(cardNumberFormatter.unformattedCardNumber(newText))
        if let position = textField.positionFromPosition(textField.beginningOfDocument, offset: cursorPositionAfterChanges) {
            textField.selectedTextRange = textField.textRangeFromPosition(position, toPosition: position)
            
            print("Cursor after formatting: \(position)")
        }
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
                self.setTextAndCursorPositionForTextField(textField, newText: newText)
                
                return false
            } else if partialValidation == CardValidationResult.Valid {
                self.userEnteredPartiallyValidCardNumber(parsedCardNumber)
                self.setTextAndCursorPositionForTextField(textField, newText: newText)
                
                return false
            } else {
                return false
            }
        }
        
        return newTextIsNumeric
    }
    
    // MARK: - Card detail animation
    
    private func animateOpenDetail() {
        self.rightView?.frame.origin.x = self.bounds.width - self.rightViewWidth
        self.rightView?.frame.size.width = self.bounds.width - self.leftViewWidth
        UIView.animateWithDuration(0.7, animations: {
            self.rightView?.frame.origin.x = self.bounds.origin.x + self.leftViewWidth
            self.rightView?.frame.size.width = self.bounds.width - self.leftViewWidth
            }, completion: { _ -> Void in
                self.cardDetailForm?.cvcTextField?.becomeFirstResponder()
        })
    }
    
    private func animateCloseDetail() {
        UIView.animateWithDuration(0.7, animations: {
            if var frame = self.rightView?.frame {
                frame.origin.x = self.bounds.width
                self.rightView?.frame.origin = frame.origin
            }
            }, completion: { _ -> Void in
                self.rightView?.removeFromSuperview()
                self.rightView = nil
        })
    }
    
    // MARK: - Card detail form delegate
    
    public func cardDetailFormDidFinish(form: CardDetailForm, withCVC cvc: CardCVC, withExpiry expiry: CardExpiry) {
        // Notify own delegate about this
        // ...
        
        // Dismiss the detail view
        self.animateCloseDetail()
    }
    
    public func cardDetailFormShouldDismiss() {
        // Dismiss the detail view
        self.animateCloseDetail()
    }
}
