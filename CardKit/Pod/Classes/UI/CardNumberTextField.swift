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

public class CardNumberTextField: UITextField, UITextFieldDelegate, CardNumberInputTextFieldDelegate {
    
    // MARK: - Public variables
    @IBOutlet public weak var cardImageView: UIImageView!
    @IBOutlet public weak var cardNumberInputTextField: CardNumberInputTextField!
    @IBOutlet public weak var cvcTextField: StylizedTextField!
    @IBOutlet public weak var monthTextField: StylizedTextField!
    @IBOutlet public weak var yearTextField: StylizedTextField!
    @IBOutlet public weak var cardInfoView: UIView?
    
    public override func deleteBackward() {
        super.deleteBackward()
        
        if (text ?? "").isEmpty {
            resignFirstResponder()
        }
    }
    
    override public var textColor: UIColor? {
        didSet {
        let textFieldArray: [UITextField?] = [cardNumberInputTextField, cvcTextField, monthTextField, yearTextField]
        textFieldArray.forEach({$0?.textColor = textColor})
        }
    }
    public override var backgroundColor: UIColor? {
        didSet {
        cardNumberInputTextField?.backgroundColor = backgroundColor
        cardImageView?.backgroundColor = backgroundColor
        }
    }
    public override var font: UIFont? {
        didSet {
        let textFieldArray: [UITextField?] = [cardNumberInputTextField, cvcTextField, monthTextField, yearTextField]
        textFieldArray.forEach({$0?.font = font})
        }
    }
    public override var keyboardType: UIKeyboardType {
        didSet {
        let textFieldArray: [UITextField?] = [cardNumberInputTextField, cvcTextField, monthTextField, yearTextField]
        textFieldArray.forEach({$0?.keyboardType = keyboardType})
        }
    }
    public override var secureTextEntry: Bool {
        didSet {
        let textFieldArray: [UITextField?] = [cardNumberInputTextField, cvcTextField, monthTextField, yearTextField]
        textFieldArray.forEach({$0?.secureTextEntry = secureTextEntry})
        }
    }
    public override var keyboardAppearance: UIKeyboardAppearance {
        didSet {
        let textFieldArray: [UITextField?] = [cardNumberInputTextField, cvcTextField, monthTextField, yearTextField]
        textFieldArray.forEach({$0?.keyboardAppearance = keyboardAppearance})
        }
    }
    public var unknownCardTypeImage: UIImage? = UIImage(named: "Unknown")
    public var cardTypeRegister: CardTypeRegister = CardTypeRegister.sharedCardTypeRegister
    public var cardNumber: CardNumber?
    public var cardCVC: CardCVC?
    public override var placeholder: String? {
        didSet {
        cardNumberInputTextField.placeholder = placeholder
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
    
    // MARK: - Initializers & view setup
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupTextFieldAttributes() {
        cardNumberInputTextField.placeholder = placeholder
        cardNumberInputTextField?.cardNumberInputTextFieldDelegate = self
        cardNumberInputTextField.addTarget(self, action: Selector("textFieldDidBeginEditing:"), forControlEvents: UIControlEvents.EditingDidBegin)
        cvcTextField?.delegate = self
        monthTextField?.delegate = self
        yearTextField?.delegate = self
        clipsToBounds = true
        
        cvcTextField.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions.New, context: nil)
        [cardNumberInputTextField,cvcTextField,monthTextField,yearTextField].forEach({
            $0.keyboardType = .NumberPad
            $0.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            $0.textColor = textColor
            $0.font = font
            $0.keyboardAppearance = keyboardAppearance
            $0.secureTextEntry = secureTextEntry
        })
        cvcTextField.deleteBackwardCallback = {_ -> Void in self.yearTextField?.becomeFirstResponder()}
        monthTextField.deleteBackwardCallback = {_ -> Void in self.cardNumberInputTextField?.becomeFirstResponder()}
        yearTextField.deleteBackwardCallback = {_ -> Void in self.monthTextField?.becomeFirstResponder()}
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
        if textField == cardNumberInputTextField {
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
        // For text fields other than the card number text field (which implements input validation on its own), validate the input
        
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
        // Check for a detected card number type
        
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
        if let rect = cardNumberInputTextField.rectForLastGroup() {
            cardNumberInputTextField.transform = CGAffineTransformTranslate(self.cardNumberInputTextField.transform, -rect.origin.x, 0)
        }
    }
    
    /**
     Moves the card number text field to its original position.
     */
    public func moveNumberFieldRight() {
        cardNumberInputTextField.transform = CGAffineTransformIdentity
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
            if cardNumberInputTextField.pointInside(point, withEvent: event) {
                cardNumberInputTextField.becomeFirstResponder()
            }
        })
    }
    
    public override func becomeFirstResponder() -> Bool {
        // Return false, since this text view is only for background style purposes
        return false
    }
}
