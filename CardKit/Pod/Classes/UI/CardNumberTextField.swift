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
public class CardNumberTextField: UITextField, UITextFieldDelegate, CardNumberInputTextFieldDelegate {
    
    // MARK: - Public variables
    @IBOutlet public weak var cardImageView: UIImageView!
    @IBOutlet public weak var numberTextField: CardNumberInputTextField!
    @IBOutlet public weak var cvcTextField: UITextField!
    @IBOutlet public weak var monthTextField: UITextField!
    @IBOutlet public weak var yearTextField: UITextField!
    @IBOutlet public weak var cardInfoView: UIView?
    override public var textColor: UIColor? {
        didSet {
        [numberTextField, cvcTextField, monthTextField, yearTextField].forEach({$0?.textColor = textColor})
        }
    }
    public override var backgroundColor: UIColor? {
        didSet {
        numberTextField?.backgroundColor = backgroundColor
        cardImageView?.backgroundColor = backgroundColor
        }
    }
    public override var font: UIFont? {
        didSet {
        [numberTextField, cvcTextField, monthTextField, yearTextField].forEach({$0?.font = font})
        }
    }
    public var unknownCardTypeImage: UIImage? = UIImage(named: "Unknown")
    public var cardTypeRegister: CardTypeRegister = CardTypeRegister.sharedCardTypeRegister
    public var cardNumber: CardNumber?
    public var cardCVC: CardCVC?
    public override var placeholder: String? {
        didSet {
        numberTextField.placeholder = placeholder
        super.placeholder = nil
        }
    }
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
    public var cardType: CardType.Type? {
        guard let number = cardNumber else {
            return nil
        }
        
        return cardTypeRegister.cardTypeForNumber(number)
    }
    
    // MARK: - Private variables
    private var monthString: String?
    private var yearString: String?
    
    // MARK: - Initializers
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //numberTextField.layer.mask = gradientMask
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    private func setupTextFieldAttributes() {
        numberTextField.placeholder = placeholder
        numberTextField?.cardNumberInputTextFieldDelegate = self
        numberTextField.addTarget(self, action: Selector("textFieldDidBeginEditing:"), forControlEvents: UIControlEvents.EditingDidBegin)
        cvcTextField?.delegate = self
        monthTextField?.delegate = self
        yearTextField?.delegate = self
        clipsToBounds = true
        
        
        cvcTextField.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions.New, context: nil)
        
        [numberTextField,cvcTextField,monthTextField,yearTextField].forEach({
            $0.keyboardType = .NumberPad
        })
        
        [numberTextField, cvcTextField, monthTextField, yearTextField].forEach({
            $0.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        })
        
        
        [numberTextField, cvcTextField, monthTextField, yearTextField].forEach({
            $0.textColor = textColor
            $0.font = font
        })
        
        super.textColor = UIColor.clearColor()
        super.placeholder = nil
    }
    
    private func setupView() {
        guard let nib = getNibBundle().loadNibNamed(getNibName(), owner: self, options: nil), let firstObjectInNib = nib.first as? UIView else {
            fatalError("The nib is expected to contain two views:\n-   The first view with the 'cardImageView' located left of the 'numberTextField'\n-   The second view with 'cvcTextField', 'cvcTextField' and 'cvcTextField' (situated in that order from left to right).")
        }
        
        firstObjectInNib.autoresizesSubviews = true
        firstObjectInNib.translatesAutoresizingMaskIntoConstraints = true
        firstObjectInNib.frame = bounds
        addSubview(firstObjectInNib)
        
        cardImageView.image = unknownCardTypeImage
        cardImageView.backgroundColor = backgroundColor ?? UIColor.whiteColor()
        
        setupTextFieldAttributes()
    }
    
    public override func becomeFirstResponder() -> Bool {
        return false
    }
    
    public override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let secondaryView = cardInfoView {
            if secondaryView.superview != superview {
                superview?.addSubview(secondaryView)
            }
        }
        
        cardInfoView?.frame = bounds
        
        //cardInfoView?.autoresizesSubviews = false
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        moveCardDetailViewOut()
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
        return NSBundle(forClass: CardNumberTextField.self)
    }
    
    // MARK: - Validity checks
    
    public func isCVCValid(cvc: String, partiallyValid: Bool) -> Bool {
        if cvc.length() == 0 && partiallyValid {
            return true
        }
        return (cardType?.validateCVC(cvc) == .Valid) ?? false || partiallyValid && (cardType?.validateCVC(cvc) == .CVCIncomplete) ?? false
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
            UIView.animateWithDuration(1.0, animations: { [unowned self] _ in
                self.moveCardDetailViewOut()
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
    
    public func cardNumberInputTextField(cardNumberTextField: CardNumberInputTextField, didChangeText text: String) {
        if let cardNumber = cardNumberTextField.parsedCardNumber {
            cardImageView.image = cardTypeRegister.cardTypeForNumber(cardNumber)?.cardTypeImage() ?? unknownCardTypeImage
        }
    }
    
    
    public func cardNumberInputTextField(cardNumberTextField: CardNumberInputTextField, didEnterValidCardNumber cardNumber: CardNumber) {
        UIView.animateWithDuration(1.0, animations: { [unowned self] _ in
            self.moveNumberFieldLeft()
            self.moveCardDetailViewIn()
        })
        
        self.cardNumber = cardNumber
        
        monthTextField.becomeFirstResponder()
    }
    
    // MARK: - View animations
    
    /**
     Translates the card number text field outside the screen.
     */
    public func moveNumberFieldLeft() {
        if let rect = numberTextField.rectForLastGroup() {
            numberTextField.transform = CGAffineTransformTranslate(self.numberTextField.transform, -rect.origin.x, 0)
        }
    }
    
    /**
     Moves the card number text field to its original position.
     */
    public func moveNumberFieldRight() {
        numberTextField.transform = CGAffineTransformIdentity
    }
    
    /**
     Shows the card detail view with CVC, month and year text field.
     */
    public func moveCardDetailViewIn() {
        cardInfoView?.transform = CGAffineTransformIdentity
    }
    
    /**
     Hides the card detail view with CVC, month and year text field by moving it outside the view.
     */
    public func moveCardDetailViewOut() {
        cardInfoView?.transform = CGAffineTransformMakeTranslation(superview!.bounds.width, 0)
    }
    
    // MARK: - UIView methods
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // If moving to a larger screen size and not showing the detail view, make sure that it is outside the view.
        if let transform = cardInfoView?.transform where !CGAffineTransformIsIdentity(transform) {
            moveCardDetailViewOut()
        }
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Detect touches in card number text field as long as the detail view is on top of it
        touches.forEach({
            let point = $0.locationInView(self)
            if numberTextField.pointInside(point, withEvent: event) {
                numberTextField.becomeFirstResponder()
            }
        })
    }
}
