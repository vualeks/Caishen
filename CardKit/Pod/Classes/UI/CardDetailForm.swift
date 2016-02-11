//
//  CardDetailForm.swift
//  Pods
//
//  Created by Daniel Vancura on 2/10/16.
//
//

import UIKit

private extension UITextField {
    func deleteBackward() {
        
    }
}

public class CardDetailForm: UIView, UITextFieldDelegate {

    @IBOutlet public weak var cvcTextField: UITextField? {
        didSet {
            self.cvcTextField?.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            cvcTextField?.delegate = self
        }
    }
    @IBOutlet public weak var monthTextField: UITextField? {
        didSet {
            self.monthTextField?.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            monthTextField?.delegate = self
        }
    }
    @IBOutlet public weak var yearTextField: UITextField? {
        didSet {
            self.yearTextField?.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            yearTextField?.delegate = self
        }
    }
    
    public var delegate: CardDetailFormDelegate?
    public var cardType: CardType = .Unknown
    private var cvcString: String?
    private var monthString: String?
    private var yearString: String?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.postInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.postInit()
    }
    
    internal func postInit() {
        
    }
    
    private func checkPartiallyValidCVC(cvcString: String) -> Bool {
        let cvcValidator = CardCVCValidator()
        let validationResult = cvcValidator.validateCVC(CardCVC(string: cvcString), forCardType: self.cardType)
        return validationResult == CardValidationResult.CVCIncomplete || validationResult == CardValidationResult.Valid
    }
    
    private func checkValidCVC(cvcString: String) -> Bool {
        let cvcValidator = CardCVCValidator()
        let validationResult = cvcValidator.validateCVC(CardCVC(string: cvcString), forCardType: self.cardType)
        return validationResult == CardValidationResult.Valid
    }
    
    private func checkValidMonth(monthString: String) -> Bool {
        guard let month = UInt(monthString) where monthString.length() <= 2 else {
            return false
        }
        
        if monthString.length() == 1 {
            return ["0","1"].contains(monthString)
        } else {
            return month >= 1 && month <= 12
        }
    }
    
    private func checkValidYear(yearString: String) -> Bool {
        guard let year = UInt(yearString) where yearString.length() <= 2 else {
            return false
        }
        
        return year < 100
    }
    
    private func checkExpiry(expiry: CardExpiry) -> Bool {
        let expiryValidator = CardExpiryDateValidator()
        
        let validationResult = expiryValidator.validateExpiry(expiry)
        
        return validationResult == CardValidationResult.Valid
    }
    
    private func checkComplete() -> Bool {
        guard let monthString = monthString, let yearString = yearString, let cvcString = cvcString else {
            return false
        }
        
        return self.checkValidCVC(cvcString) && self.checkValidMonth(monthString) && self.checkValidYear(yearString)
    }
    
    private func nextResponderInChain(textField: UITextField?) -> UITextField? {
        if let textField = textField where textField == self.cvcTextField {
            return self.monthTextField
        } else if let textField = textField where textField == self.monthTextField {
            return self.yearTextField
        }
        return nil
    }
    
    private func previousResponderInChain(textField: UITextField?) -> UITextField? {
        if let textField = textField where textField == self.monthTextField {
            return self.cvcTextField
        } else if let textField = textField where textField == self.yearTextField {
            return self.monthTextField
        }
        return nil
    }
    
    private func textInputIsValid(textInput: String, forTextField textField: UITextField) -> Bool {
        if textInput == "" {
            return true
        }
        
        switch textField {
        case let val where val == self.cvcTextField:
            return checkPartiallyValidCVC(textInput)
        case let val where val == self.monthTextField:
            return self.checkValidMonth(textInput)
        case let val where val == self.yearTextField:
            return self.checkValidYear(textInput)
        default:
            return false
        }
    }
    
    private func textInputIsComplete(textInput: String, forTextField textField: UITextField) -> Bool {
        switch textField {
        case let val where val == self.cvcTextField:
            return self.checkValidCVC(textInput)
        case let val where val == self.monthTextField:
            return self.checkValidMonth(textInput) && textInput.length() == 2
        case let val where val == self.yearTextField:
            return self.checkValidYear(textInput) && textInput.length() == 2
        default:
            return false
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        let text = textField.text ?? ""
        
        if self.textInputIsComplete(text, forTextField: textField) {
            self.nextResponderInChain(textField)?.becomeFirstResponder()
        } else if text == "" {
            if textField == self.cvcTextField {
                self.delegate?.cardDetailFormShouldDismiss()
            } else {
                self.previousResponderInChain(textField)?.becomeFirstResponder()
            }
        }
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
    }
    
    public func textField(var textField: UITextField, var shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let modifiedText = NSString(string: textField.text ?? "").stringByReplacingCharactersInRange(range, withString: string)
        if self.textInputIsComplete(textField.text ?? "", forTextField: textField) && modifiedText.length() > (textField.text ?? "").length() {
            if let nextResponder = self.nextResponderInChain(textField) {
                textField = nextResponder
                textField.becomeFirstResponder()
                range = NSMakeRange(0, textField.text?.length() ?? 0)
            }
        }
        
        let newString = NSString(string: textField.text ?? "").stringByReplacingCharactersInRange(range, withString: string)
        
        return self.textInputIsValid(newString, forTextField: textField)
    }
}
