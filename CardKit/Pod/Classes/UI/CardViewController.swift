//
//  CardView.swift
//  Pods
//
//  Created by Daniel Vancura on 2/12/16.
//
//

import UIKit

public enum CardViewLoaderError: ErrorType {
    case LoadingFailed(nibName: String)
    case SuperViewIsCardView
}

@IBDesignable
public class CardViewController: UIViewController, UITextFieldDelegate, CardNumberTextFieldDelegate {
    @IBOutlet public weak var cardImageView: UIImageView!
    @IBOutlet public weak var numberTextField: CardNumberTextField!
    @IBOutlet public weak var cvcTextField: UITextField!
    @IBOutlet public weak var monthTextField: UITextField!
    @IBOutlet public weak var yearTextField: UITextField!
    
    @IBOutlet public weak var cardInfoView: UIView?
    public var cardNumber: CardNumber?
    public var cardCVC: CardCVC?
    public var cardExpiry: CardExpiry? {
        guard let month = monthString, year = yearString else {
            return nil
        }
        return CardExpiry(month: month, year: year)
    }
    public var cardType: CardType {
        guard let number = cardNumber else {
            return CardType.Unknown
        }
        
        return CardType.CardTypeForNumber(number)
    }
    @IBInspectable
    private var monthString: String?
    private var yearString: String?
    
    public override func loadView() {
        super.loadView()
        
        if let view = view,
            let cardInfoView = cardInfoView,
            let cardImageView = cardImageView,
            let numberTextField = numberTextField,
            let cvcTextField = cvcTextField,
            let monthTextField = monthTextField,
            let yearTextField = yearTextField {
                return
        }
        guard let nib = getNibBundle().loadNibNamed(getNibName(), owner: self, options: nil) where nib.count > 1, let firstObjectInNib = nib.first as? UIView,
            let secondObjectInNib = nib[1] as? UIView else {
                fatalError("The nib is expected to contain two views:\n-   The first view with the 'cardImageView' located left of the 'numberTextField'\n-   The second view with 'cvcTextField', 'cvcTextField' and 'cvcTextField' (situated in that order from left to right).")
        }
        self.view = firstObjectInNib
        self.cardInfoView = secondObjectInNib
        
        guard let cardImageView = cardImageView,
            let numberTextField = numberTextField,
            let cvcTextField = cvcTextField,
            let monthTextField = monthTextField,
            let yearTextField = yearTextField else {
                fatalError("Some outlets have not been assigned in the provided Nib. Please check the outlet links for 'cardImageView', 'numberTextField', 'cvcTextField', 'monthTextField', 'yearTextField'")
        }
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        cardImageView.image = UIImage(named: CardType.imageNameForCardType(.Unknown))
        numberTextField?.cardNumberTextFieldDelegate = self
        numberTextField.addTarget(self, action: Selector("textFieldDidBeginEditing:"), forControlEvents: UIControlEvents.EditingDidBegin)
        cvcTextField?.delegate = self
        monthTextField?.delegate = self
        yearTextField?.delegate = self
        
        [numberTextField,cvcTextField,monthTextField,yearTextField].forEach({
            $0.keyboardType = .NumberPad
        })
        
        [numberTextField, cvcTextField, monthTextField, yearTextField].forEach({
            $0.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        })
    }
    
    public override func viewWillAppear(animated: Bool) {
        if let secondaryView = cardInfoView {
            if secondaryView.superview != view.superview {
                view.addSubview(secondaryView)
            }
        }
        cardInfoView?.frame = view.frame
        cardInfoView?.frame.origin = view.frame.origin
        moveSecondaryViewOut()
        
        cardInfoView?.autoresizesSubviews = false
    }
    
    public func getNibName() -> String {
        return "CardView"
    }
    
    public func getNibBundle() -> NSBundle {
        return NSBundle(forClass: self.dynamicType)
    }
    
    // MARK: - Validity checks
    
    private func isCVCValid(cvc: String, partiallyValid: Bool) -> Bool {
        if cvc.length() == 0 && partiallyValid {
            return true
        }
        return CardCVCValidator().validateCVC(CardCVC(string: cvc), forCardType: self.cardType) == .Valid || partiallyValid && CardCVCValidator().validateCVC(CardCVC(string: cvc), forCardType: self.cardType) == .CVCIncomplete
    }
    
    private func isMonthValid(month: String, partiallyValid: Bool) -> Bool {
        if partiallyValid && month.length() == 0 {
            return true
        }
        
        guard let monthInt = UInt(month) else {
            return false
        }
        
        if month.length() == 1 && !["0","1"].contains(month) {
            return false
        }
        
        return ((monthInt >= 1 && monthInt <= 12) || (partiallyValid && month == "0")) && (partiallyValid || month.length() == 2)
    }
    
    private func isYearValid(year: String, partiallyValid: Bool) -> Bool {
        if partiallyValid && year.length() == 0 {
            return true
        }
        
        guard let yearInt = UInt(year) else {
            return false
        }
        
        return yearInt >= 0 && yearInt < 100 && (partiallyValid || year.length() == 2)
    }
    
    // MARK: - Text field delegate
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        if textField == numberTextField {
            UIView.animateWithDuration(1.0, animations: {
                self.moveSecondaryViewOut()
                self.moveNumberFieldRight()
            })
        }
    }
    
    public func textFieldDidChange(textField: UITextField) {
        switch textField {
        case cvcTextField:
            if isCVCValid(textField.text ?? "", partiallyValid: false) {
                cardCVC = CardCVC(string: textField.text!)
            }
        case monthTextField:
            if isMonthValid(textField.text ?? "", partiallyValid: false) {
                monthString = textField.text!
                yearTextField.becomeFirstResponder()
            }
        case yearTextField:
            if isYearValid(textField.text ?? "", partiallyValid: false) {
                yearString = textField.text!
                cvcTextField.becomeFirstResponder()
            }
        default:
            break
        }
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newValue = NSString(string: textField.text ?? "").stringByReplacingCharactersInRange(range, withString: string)
        switch textField {
        case cvcTextField:
            return isCVCValid(newValue, partiallyValid: true)
        case monthTextField:
            return isMonthValid(newValue, partiallyValid: true)
        case yearTextField:
            return isYearValid(newValue, partiallyValid: true)
        default:
            return true
        }
    }
    
    // MARK: - CardNumberTextFieldDelegate
    
    public func cardNumberTextField(cardNumberTextField: CardNumberTextField, didChangeText text: String) {
        if let cardNumber = cardNumberTextField.parsedCardNumber {
            cardImageView.image = UIImage(named: CardType.imageNameForCardType(CardType.CardTypeForNumber(cardNumber)))
        }
    }
    
    public func cardNumberTextField(cardNumberTextField: CardNumberTextField, didEnterValidCardNumber cardNumber: CardNumber) {
        
        UIView.animateWithDuration(1.0, animations: {
            self.moveNumberFieldLeft()
            self.moveSecondaryViewIn()
        })
        
        self.cardNumber = cardNumber
        
        monthTextField.becomeFirstResponder()
    }
    
    // MARK: - View animations
    
    private func moveNumberFieldLeft() {
        if let rect = numberTextField.rectForLastGroup() {
            numberTextField.transform = CGAffineTransformTranslate(self.numberTextField.transform, -rect.origin.x, 0)
        }
    }
    
    private func moveNumberFieldRight() {
        numberTextField.transform = CGAffineTransformIdentity
    }
    
    private func moveSecondaryViewIn() {
        cardInfoView?.transform = CGAffineTransformIdentity
    }
    
    private func moveSecondaryViewOut() {
        cardInfoView?.transform = CGAffineTransformMakeTranslation(view.bounds.width, 0)
    }
    
    // MARK: - UIView methods
    
    public override func viewWillLayoutSubviews() {
        view.superview?.clipsToBounds = true
        view.frame.size.width = view.superview?.frame.width ?? view.frame.width
        cardInfoView?.frame.size.width = view.superview?.frame.width ?? cardInfoView!.frame.width
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Detect touches in card number text field as long as the detail view is on top of it
        touches.forEach({
            let point = $0.locationInView(view)
            if numberTextField.pointInside(point, withEvent: event) {
                numberTextField.becomeFirstResponder()
            }
        })
    }
}
