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
    @IBInspectable public var textColor: UIColor?
    public var cardNumber: CardNumber?
    public var cardCVC: CardCVC?
    public var cardExpiry: CardExpiry? {
        set {
            guard let components = newValue?.stringValue().componentsSeparatedByString("/") where components.count == 2 else {
                return
            }
            guard components[0].length() == 2 && components[1].length() == 4 else {
                return
            }
            
            monthString = components[0]
            yearString = components[1][2,4]
        }
        get {
            guard let month = monthString, year = yearString else {
                return nil
            }
            return CardExpiry(month: month, year: year)
        }
    }
    public var cardType: CardType {
        guard let number = cardNumber else {
            return CardType.Unknown
        }
        
        return CardType.CardTypeForNumber(number)
    }
    private var monthString: String?
    private var yearString: String?
    
    public final override func loadView() {
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
        guard let nib = getNibBundle().loadNibNamed(getNibName(), owner: self, options: nil), let firstObjectInNib = nib.first as? UIView else {
            fatalError("The nib is expected to contain two views:\n-   The first view with the 'cardImageView' located left of the 'numberTextField'\n-   The second view with 'cvcTextField', 'cvcTextField' and 'cvcTextField' (situated in that order from left to right).")
        }
        self.view = firstObjectInNib
        
        guard let cardImageView = cardImageView,
            let numberTextField = numberTextField,
            let cvcTextField = cvcTextField,
            let monthTextField = monthTextField,
            let yearTextField = yearTextField else {
                fatalError("Some outlets have not been assigned in the provided Nib. Please check the outlet links for 'cardImageView', 'numberTextField', 'cvcTextField', 'monthTextField', 'yearTextField'")
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        cardImageView.image = UIImage(named: CardType.imageNameForCardType(.Unknown))
        numberTextField?.cardNumberTextFieldDelegate = self
        numberTextField.addTarget(self, action: Selector("textFieldDidBeginEditing:"), forControlEvents: UIControlEvents.EditingDidBegin)
        cvcTextField?.delegate = self
        monthTextField?.delegate = self
        yearTextField?.delegate = self
        
        cvcTextField.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions.New, context: nil)
        
        [numberTextField,cvcTextField,monthTextField,yearTextField].forEach({
            $0.keyboardType = .NumberPad
        })
        
        [numberTextField, cvcTextField, monthTextField, yearTextField].forEach({
            $0.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        })
        
        if let textColor = textColor {
            [numberTextField, monthTextField, yearTextField, cvcTextField].forEach({
                $0?.textColor = textColor
            })
        }
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "text" {
            
        }
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
        
        //cardInfoView?.autoresizesSubviews = false
    }
    
    // MARK: - View customization
    
    /**
     You can override this function to provide your own Nib. If you do so, please override 'getNibBundle' as well to provide the right NSBundle to load the nib file. The Nibs you provide are expected to be structured in a specific way.
     
     **Alternatively:**
     Assign all outlets in your Storyboard. If all outlets have been assigned, a CardViewController will not opt for the Nib.
     */
    public func getNibName() -> String {
        return "CardView"
    }
    
    /**
     You can override this function to provide the NSBundle for your own Nib. If you do so, please override 'getNibName' as well to provide the right Nib to load the nib file. The Nibs you provide are expected to be structured in a specific way.
     
     **Alternatively:**
     Assign all outlets in your Storyboard. If all outlets have been assigned, a CardViewController will not opt for the Nib.
     */
    public func getNibBundle() -> NSBundle {
        return NSBundle(forClass: self.dynamicType)
    }
    
    // MARK: - Validity checks
    
    public func isCVCValid(cvc: String, partiallyValid: Bool) -> Bool {
        if cvc.length() == 0 && partiallyValid {
            return true
        }
        return CardCVCValidator().validateCVC(CardCVC(string: cvc), forCardType: self.cardType) == .Valid || partiallyValid && CardCVCValidator().validateCVC(CardCVC(string: cvc), forCardType: self.cardType) == .CVCIncomplete
    }
    
    public func isMonthValid(month: String, partiallyValid: Bool) -> Bool {
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
    
    public func isYearValid(year: String, partiallyValid: Bool) -> Bool {
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
    
    public final func textFieldDidChange(textField: UITextField) {
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
    
    public final func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
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
    
    public func moveNumberFieldLeft() {
        if let rect = numberTextField.rectForLastGroup() {
            numberTextField.transform = CGAffineTransformTranslate(self.numberTextField.transform, -rect.origin.x, 0)
        }
    }
    
    public func moveNumberFieldRight() {
        numberTextField.transform = CGAffineTransformIdentity
    }
    
    public func moveSecondaryViewIn() {
        cardInfoView?.transform = CGAffineTransformIdentity
    }
    
    public func moveSecondaryViewOut() {
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
