//
//  CardView.swift
//  Pods
//
//  Created by Daniel Vancura on 2/12/16.
//
//

import UIKit

/**
 This kind of text field serves as a container for subviews, which allow a user to enter card information.
 
 The typical structure of a `CardNumberTextField`'s subviews is as follows:
 - _: UIView (in most cases with a transparent background in order to not hide the CardNumberTextField)
    - cardImageView: UIImageView
    - CardNumberInputTextField (for entering a card number)
        - cardInfoView: UIView (container for other views to enter additional information after entering a valid card number) with subviews ordered from left to right:
            - monthTextField: StylizedTextField
            - yearTextField: StylizedTextField
            - cvcTextField: StylizedTextField
 
 In order to create a custom CardNumberTextField, you can create a subclass which overrides `getNibName()` and `getNibBundle()` in order to load a nib from a specific bundle, which follows this structure
 */
@IBDesignable
public class CardNumberTextField: UITextField, UITextFieldDelegate, CardNumberInputTextFieldDelegate {
    
    // MARK: - Public variables
    
    /**
     The image view which is used to display the detected card type.
     */
    @IBOutlet public weak var cardImageView: UIImageView?
    
    /**
     A but which is shown only when the delegate's 
     */
    @IBOutlet public weak var accessoryButton: UIButton?
    
    /**
     The formatted text field which is used to enter the card number.
     */
    @IBOutlet public weak var cardNumberInputTextField: CardNumberInputTextField?
    
    /**
     The text field which is used to enter the card validation code.
     */
    @IBOutlet public weak var cvcTextField: StylizedTextField?
    
    /**
     The text field which is used to enter the month of the expiry date.
     */
    @IBOutlet public weak var monthTextField: StylizedTextField?
    
    /**
     The text field which is used to enter the year of the expiry date.
     */
    @IBOutlet public weak var yearTextField: StylizedTextField?
    
    /**
     The view which is slided in from the right after a valid card number has been entered.
     */
    @IBOutlet public weak var cardInfoView: UIView?
    
    public var cardNumberTextFieldDelegate: CardNumberTextFieldDelegate? {
        didSet {
        setupAccessoryButton()
        }
    }
    
    override public final var textColor: UIColor? {
        didSet {
        let textFieldArray: [UITextField?] = [cardNumberInputTextField, cvcTextField, monthTextField, yearTextField]
        textFieldArray.forEach({$0?.textColor = textColor})
        }
    }
    public override final var backgroundColor: UIColor? {
        didSet {
        cardNumberInputTextField?.backgroundColor = backgroundColor
        cardImageView?.backgroundColor = backgroundColor
        }
    }
    public override final var font: UIFont? {
        didSet {
        let textFieldArray: [UITextField?] = [cardNumberInputTextField, cvcTextField, monthTextField, yearTextField]
        textFieldArray.forEach({$0?.font = font})
        }
    }
    public override final var keyboardType: UIKeyboardType {
        didSet {
        let textFieldArray: [UITextField?] = [cardNumberInputTextField, cvcTextField, monthTextField, yearTextField]
        textFieldArray.forEach({$0?.keyboardType = keyboardType})
        }
    }
    public override final var secureTextEntry: Bool {
        didSet {
        let textFieldArray: [UITextField?] = [cardNumberInputTextField, cvcTextField, monthTextField, yearTextField]
        textFieldArray.forEach({$0?.secureTextEntry = secureTextEntry})
        }
    }
    public override final var keyboardAppearance: UIKeyboardAppearance {
        didSet {
        let textFieldArray: [UITextField?] = [cardNumberInputTextField, cvcTextField, monthTextField, yearTextField]
        textFieldArray.forEach({$0?.keyboardAppearance = keyboardAppearance})
        }
    }
    
    /**
     The string value that is used to separate the different groups of a card number in the text field.
     */
    @IBInspectable
    public var cardNumberSeparator = " - "
    
    @IBInspectable
    public var invalidNumberColor: UIColor? {
        didSet {
        if let invalidNumberColor = invalidNumberColor {
            cardNumberInputTextField?.invalidInputColor = invalidNumberColor
        }
        }
    }
    
    /**
     The currently entered card, or nil, if some of the card information is missing.
     */
    public var card: Card? {
        get {
            guard let cardNumber = cardNumber, let cardCVC = cardCVC, let cardExpiry = cardExpiry else {
                return nil
            }
            return Card(bankCardNumber: cardNumber, cardVerificationCode: cardCVC, expiryDate: cardExpiry)
        }
    }
    /**
     The image that is displayed if the currently entered card number does not match any card types
     */
    public var unknownCardTypeImage: UIImage? = UIImage(named: "Unknown") ?? UIImage(named: "Unknown", inBundle: NSBundle(forClass: CardNumberTextField.self), compatibleWithTraitCollection: nil)
    
    /**
     This card type register contains a list of all valid card types. You can provide separate card type registers for different card number text fields.
     By default, CardTypeRegister.sharedCardTypeRegister is used.
     */
    public var cardTypeRegister: CardTypeRegister = CardTypeRegister.sharedCardTypeRegister
    
    /**
     Array of all card types that are accepted by this card number text field.
     */
    public var validCardTypes: [CardType] {
        get {
            return cardTypeRegister.registeredCardTypes
        }
        set {
            cardTypeRegister.setRegisteredCardTypes(newValue)
        }
    }
    #if !TARGET_INTERFACE_BUILDER
    public override var placeholder: String? {
        didSet {
        cardNumberInputTextField?.placeholder = placeholder
        super.placeholder = nil
        }
    }
    #endif
    
    /**
     The card expiry of the card number or nil, if a valid expiry has not been entered yet.
     */
    public final var cardExpiry: Expiry? {
        get {
            guard let month = monthString, year = yearString else {
                return nil
            }
            return Expiry(month: month, year: year)
        } set {
            guard let components = newValue?.stringValue().componentsSeparatedByString("/") where components.count == 2 else {
                return
            }
            guard components[0].characters.count == 2 && components[1].characters.count == 4 else {
                return
            }
            
            monthString = components[0]
            yearString = components[1][2,4]
        }
    }
    
    /**
     The card type for the entered card number or nil, if no card type has been detected with the given input.
     */
    public final var cardType: CardType? {
        guard let number = cardNumberInputTextField?.parsedCardNumber else {
            return nil
        }
        
        return cardTypeRegister.cardTypeForNumber(number)
    }
    
    // MARK: - Internal variables
    
    /**
    The string that has been entered for the month of the expiry date or nil, if no valid month has been entered yet.
    */
    internal var monthString: String?
    
    /**
     The string that has been entered for the year of the expiry date or nil, if no valid year has been entered yet.
     */
    internal var yearString: String?
    
    /**
     The entered card validation code or nil, if no valid cvc has been entered yet.
     */
    internal var cardCVC: CVC?
    
    // MARK: - Private variables
    
    /**
     The entered card number or nil, if no valid card number has been entered yet.
     */
    private var cardNumber: Number? {
        guard let number = cardNumberInputTextField?.parsedCardNumber else {
            return nil
        }

        guard let cardType = cardTypeRegister.cardTypeForNumber(number) else {
            return nil
        }

        guard cardType.validateNumber(number) == .Valid else {
            return nil
        }

        return number
    }
    
    /**
     Notifies `cardNumberTextFieldDelegate` about changes to the entered card information.
     */
    internal func notifyDelegate() {
        if let card = card {
            cardNumberTextFieldDelegate?.cardNumberTextField(self, didEnterCardInformation: card, withValidationResult: CardValidator(cardTypeRegister: cardTypeRegister).validateCard(card))
        } else {
            cardNumberTextFieldDelegate?.cardNumberTextField(self, didEnterCardInformation: nil, withValidationResult: nil)
        }
    }
    
    // MARK: - Initializers & view setup
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        #if !TARGET_INTERFACE_BUILDER
            setupView()
        #endif
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        #if !TARGET_INTERFACE_BUILDER
            setupView()
        #endif
    }
    
    /**
     Customizes text field attributes of subviews so that the appearance matches the appearance of `self`.
     */
    private func setupTextFieldAttributes() {
        cardNumberInputTextField?.cardNumberSeparator = cardNumberSeparator
        cardNumberInputTextField?.placeholder = placeholder
        cardNumberInputTextField?.cardNumberInputTextFieldDelegate = self
        cardNumberInputTextField?.addTarget(self, action: "cardNumberTextFieldDidChangeText:", forControlEvents: .EditingChanged)
        cvcTextField?.delegate = self
        monthTextField?.delegate = self
        yearTextField?.delegate = self
        clipsToBounds = true
        
        setupAccessoryButton()
        [cardNumberInputTextField,cvcTextField,monthTextField,yearTextField].forEach({
            $0?.keyboardType = .NumberPad
            $0?.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
            $0?.addTarget(self, action: Selector("textFieldDidBeginEditing:"), forControlEvents: UIControlEvents.EditingDidBegin)
            $0?.textColor = textColor
            $0?.font = font
            $0?.keyboardAppearance = keyboardAppearance
            $0?.secureTextEntry = secureTextEntry
        })
        cvcTextField?.deleteBackwardCallback = {_ -> Void in self.yearTextField?.becomeFirstResponder()}
        monthTextField?.deleteBackwardCallback = {_ -> Void in self.cardNumberInputTextField?.becomeFirstResponder()}
        yearTextField?.deleteBackwardCallback = {_ -> Void in self.monthTextField?.becomeFirstResponder()}
        super.textColor = UIColor.clearColor()
        super.placeholder = nil
    }
    
    internal func buttonReceivedAction() {
        cardNumberTextFieldDelegate?.cardNumberTextFieldShouldProvideAccessoryAction(self)?()
    }
    
    private func setupAccessoryButton() {
        guard let _ = cardNumberTextFieldDelegate?.cardNumberTextFieldShouldProvideAccessoryAction(self) else {
            accessoryButton?.alpha = 0
            return
        }
        accessoryButton?.addTarget(self, action: Selector("buttonReceivedAction"), forControlEvents: .TouchUpInside)
        accessoryButton?.alpha = 1.0
        
        if let buttonImage = cardNumberTextFieldDelegate?.cardNumberTextFieldShouldShowAccessoryImage(self) {
            let scaledImage = buttonImage.resizableImageWithCapInsets(UIEdgeInsetsZero, resizingMode: .Stretch).imageWithRenderingMode(.AlwaysTemplate)
            accessoryButton?.titleLabel?.text = nil
            accessoryButton?.setImage(scaledImage, forState: .Normal)
            accessoryButton?.tintColor = cardNumberInputTextField?.textColor
        }
    }
    
    /**
     Sets up the view by loading subviews from the given Nib in the specified bundle.
     */
    private func setupView() {
        guard let nib = getNibBundle().loadNibNamed(getNibName(), owner: self, options: nil), let firstObjectInNib = nib.first as? UIView else {
            fatalError("The nib is expected to contain two views:\n-   The first view with the 'cardImageView' located left of the 'numberTextField'\n-   The second view with 'cvcTextField', 'cvcTextField' and 'cvcTextField' (situated in that order from left to right).")
        }
        
        firstObjectInNib.autoresizesSubviews = true
        firstObjectInNib.translatesAutoresizingMaskIntoConstraints = true
        firstObjectInNib.frame = bounds
        addSubview(firstObjectInNib)
        
        cardImageView?.image = unknownCardTypeImage
        cardImageView?.backgroundColor = backgroundColor ?? UIColor.whiteColor()
        cardImageView?.layer.cornerRadius = 5.0
        setupTextFieldAttributes()
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("moveNumberFieldLeftAnimated"))
        leftSwipeGestureRecognizer.direction = .Left
        firstObjectInNib.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        [firstObjectInNib, cardInfoView].forEach({
            let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("moveNumberFieldRightAnimated"))
            rightSwipeGestureRecognizer.direction = .Right
            $0?.addGestureRecognizer(rightSwipeGestureRecognizer)
        })
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let secondaryView = cardInfoView {
            if secondaryView.superview != superview {
                superview?.addSubview(secondaryView)
            }
        }
        
        cardInfoView?.frame = bounds
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        moveNumberFieldRight()
    }
    
    // MARK: - View customization
    
    /**
     You can override this function to provide your own Nib. If you do so, please override 'getNibBundle' as well to provide the right NSBundle to load the nib file.
     */
    public func getNibName() -> String {
        return "CardView"
    }
    
    /**
     You can override this function to provide the NSBundle for your own Nib. If you do so, please override 'getNibName' as well to provide the right Nib to load the nib file.
     */
    public func getNibBundle() -> NSBundle {
        return NSBundle(forClass: CardNumberTextField.self)
    }
    
    // MARK: - CardNumberInputTextFieldDelegate

    @objc internal func cardNumberTextFieldDidChangeText(cardNumberTextField: CardNumberInputTextField) {
        if let cardNumber = cardNumberTextField.parsedCardNumber {
            cardImageView?.image = cardTypeRegister.cardTypeForNumber(cardNumber)?.cardTypeImage ?? unknownCardTypeImage
        }
        
        notifyDelegate()
    }

    public func cardNumberInputTextFieldDidComplete(cardNumberTextField: CardNumberInputTextField) {
        moveNumberFieldLeftAnimated()

        notifyDelegate()
        monthTextField?.becomeFirstResponder()
    }
    
    // MARK: - View animations
    
    internal func moveNumberFieldLeftAnimated() {
        UIView.animateWithDuration(1.0, animations: { [weak self] _ in
            self?.moveNumberFieldLeft()
            })
    }
    
    internal func moveNumberFieldRightAnimated() {
        UIView.animateWithDuration(1.0, animations: { [weak self] _ in
            self?.moveNumberFieldRight()
            })
    }
    
    /**
     Translates the card number text field outside the screen.
     */
    public func moveNumberFieldLeft() {
        // Only when the card number has been set, the user can swipe to the details
        if cardNumber == nil {
            return
        }
        
        cardNumberInputTextField?.becomeFirstResponder()
        if let rect = cardNumberInputTextField?.rectForLastGroup() {
            cardNumberInputTextField?.transform =
                CGAffineTransformMakeTranslation(-rect.origin.x, 0)
        } else {
            cardNumberInputTextField?.alpha = 0
        }
        cardNumberInputTextField?.resignFirstResponder()
        cardInfoView?.transform = CGAffineTransformIdentity
    }
    
    /**
     Moves the card number text field to its original position.
     */
    public func moveNumberFieldRight() {
        [monthTextField, yearTextField, cvcTextField].forEach({$0?.resignFirstResponder()})
        cardNumberInputTextField?.transform = CGAffineTransformIdentity
        cardNumberInputTextField?.alpha = 1
        cardInfoView?.transform = CGAffineTransformMakeTranslation(superview!.bounds.width, 0)
    }
    
    // MARK: - UIView
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // If moving to a larger screen size and not showing the detail view, make sure that it is outside the view.
        if let transform = cardInfoView?.transform where !CGAffineTransformIsIdentity(transform) {
            moveNumberFieldRight()
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Detect touches in card number text field as long as the detail view is on top of it
        touches.forEach({ touch -> () in
            let point = touch.locationInView(self)
            if (cardNumberInputTextField?.pointInside(point, withEvent: event) ?? false) && [monthTextField,yearTextField,cvcTextField].reduce(true, combine: { (currentValue: Bool, textField: UITextField?) -> Bool in
                let pointInTextField = touch.locationInView(textField)
                return currentValue && !(textField?.pointInside(pointInTextField, withEvent: event) ?? false)
            }) {
                cardNumberInputTextField?.becomeFirstResponder()
            }
        })
    }
    
    public override func becomeFirstResponder() -> Bool {
        // Return false, since this text view is only for background style purposes
        return false
    }
}
