//
//  CardNumberTextField.swift
//  Pods
//
//  Created by Daniel Vancura on 2/9/16.
//
//

import UIKit

@IBDesignable
public class CardNumberTextField: UITextField, UITextFieldDelegate {
    
    internal var parsedCardNumber: CardNumber?
    
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet {
            if borderWidth > 0 {
                self.borderStyle = .None
                self.layer.borderWidth = CGFloat(borderWidth)
            } else {
                self.borderStyle = .RoundedRect
                self.layer.borderWidth = 0
            }
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            if cornerRadius >= 0 {
                self.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            self.layer.borderColor = self.borderColor.CGColor
        }
    }
    
    @IBInspectable
    public var cardNumberSeparator: String = "-" {
        didSet {
            self.placeholder = self.cardNumberFormatter.formattedCardNumber(self.placeholder ?? "1234123412341234", forCardType: .Visa)
        }
    }
    
    @IBInspectable
    public var logoBackgroundColor: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.0) {
        didSet {
            self.cardIssuerLogoView?.backgroundColor = logoBackgroundColor
        }
    }
    
    @IBInspectable
    public var logoViewWidth: CGFloat = 30 {
        didSet {
            self.cardIssuerLogoView?.bounds.size.width = logoViewWidth
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
                self.placeholder = self.cardNumberFormatter.formattedCardNumber(placeholder, forCardType: .Visa)
            } else {
                return
            }
        }
    }
    
    private var cardType: CardType = .Unknown {
        willSet {
            if cardType != newValue {
                print(newValue)
                self.cardIssuerLogoView?.displayLogoForCardType(newValue)
            }
        }
    }
    
    private var cardNumberFormatter: CardNumberFormatter {
        get {
            return CardNumberFormatter(separator: self.cardNumberSeparator)
        }
    }
    
    /**
     The view that is displayed next to the card number text field.
     */
    public var cardIssuerLogoView: CardIssuerLogoView? {
        set {
            self.leftView = newValue
            if let _ = newValue {
                self.leftViewMode = .Always
            } else {
                self.leftViewMode = .Never
            }
        }
        get {
            return self.leftView as? CardIssuerLogoView
        }
    }
    
    private func userDidEnterValidCardNumber(number: CardNumber) {
        self.cardType = CardType.CardTypeForNumber(number)
    }
    
    private func userEnteredPartiallyValidCardNumber(number: CardNumber) {
        self.cardType = CardType.CardTypeForNumber(number)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.postInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.postInit()
    }
    
    private func postInit() {
        self.delegate = self
        self.leftViewMode = .Always
        self.leftView = CardIssuerLogoView()
        self.cardIssuerLogoView?.displayLogoForCardType(.Unknown)
        self.leftView?.contentMode = .ScaleAspectFit
        self.leftView?.clipsToBounds = true
        self.leftView?.bounds = self.bounds
        self.leftView?.bounds.size.width = self.logoViewWidth
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
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
            let cardType = CardType.CardTypeForNumber(parsedCardNumber)
            
            let partialValidation = cardNumberValidator.checkCardNumberPartiallyValid(parsedCardNumber)
            let completeValidation = cardNumberValidator.validateCardNumber(parsedCardNumber)
            
            if completeValidation == CardValidationResult.Valid {
                self.userDidEnterValidCardNumber(parsedCardNumber)
                textField.text = cardNumberFormatter.formattedCardNumber(newText, forCardType: cardType)
                return false
            } else if partialValidation == CardValidationResult.Valid {
                self.userEnteredPartiallyValidCardNumber(parsedCardNumber)
                textField.text = cardNumberFormatter.formattedCardNumber(newText, forCardType: cardType)
                return false
            } else {
                return false
            }
        }
        
        return newTextIsNumeric
    }
}
