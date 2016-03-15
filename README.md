# 💳 Caishen - Payment Card UI & Validation for iOS

## Description

Caishen provides an easy-to-use text field to ask users for payment card information and validate the input. It serves a similar purpose as [PaymentKit](https://github.com/stripe/PaymentKit), but is developed as a standalone framework entirely written in Swift. Caishen also allows an easy integration with other third-party frameworks, such as [CardIO](https://www.card.io).

## Installation

Caishen is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Caishen"
```

## Usage

### Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Inside your project

To add a text field for entering card information to a view, either ...

- ... add a UITextField to your view in InterfaceBuilder and change its class to *CardNumberTextField* (when using InterfaceBuilder)
- ... or initiate a *CardNumberTextField* with one of its initializers (when instantiating from code): 
	- init?(coder: aDecoder: NSCoder)
	- init(frame: CGRect)

To get updates about entered card information on your view controller, confirm to the protocol *CardNumberTextFieldDelegate* set the view controller as *cardNumberTextFieldDelegate* for the text field:

```swift
class MyViewController: UIViewController, CardNumberTextFieldDelegate {
	
	@IBOutlet weak var cardNumberTextField: CardNumberTextField?
	
	override func viewDidLoad() {
		cardNumberTextField?.cardNumberTextFieldDelegate = self
		
		...
	}
	
	func cardNumberTextField(cardNumberTextField: CardNumberTextField, didEnterCardInformation information: Card?, withValidationResult validationResult: CardValidationResult?) {
		// A valid card has been entered, if information is not nil and validationResult == CardValidationResult.Valid
	}
	
	func cardNumberTextFieldShouldShowAccessoryImage(cardNumberTextField: CardNumberTextField) -> UIImage? {
		// You can return an image which will be used on cardNumberTextField's accessory button
		// If you return nil but provide an accessory button action, the unicode character "⇤" is displayed instead of an image to indicate an action that affects the text field.
	}
	
	func cardNumberTextFieldShouldProvideAccessoryAction(cardNumberTextField: CardNumberTextField) -> (() -> ())? {
		// You can return a callback function which will be called if a user tapped on cardNumberTextField's accessory button
		// If you return nil, cardNumberTextField won't display an accessory button at all.
	}
	
	...
```

#### Specifying your own card types

CardNumberTextField further contains a *CardTypeRegister* which maintains a set of different card types that are accepted by this text field.
You can create your own card types and add or remove them to or from card number text fields:

```swift
struct MyCardType: CardType {
    
	// MARK: - Required
	
	// The image that will be displayed in the card number text field's image view when this card type has been detected:
    public let cardTypeImage: UIImage? = UIImage(named: "MyCardType")
	
	// The name of your specified card type:
    public let name = "My Card Type"
	
	// If the Issuer Identification Number (the first six digits of the entered card number) of a card number 
	// starts with anything from 1000 to 1111, the card is identified as being of type "MyCardType":
    public let identifyingDigits = Set(1000...1111)
	
	// MARK: - Optional
	
	// Not specifying this will assert a three digits long cvc:
	public let CVCLength = 4
	
	// Not specifying this will load a default cvc image:
    public let cvcImage: UIImage? = UIImage(named: "MyCardTypeCVCImage")
	
	// The grouping of your card number type. The following results in a card number format
	// like "100 - 0000 - 00000 - 000000":
	public let numberGrouping = [3, 4, 5, 6]
	
    public init() {
		
    }
}

...

class MyViewController: UIViewController, CardNumberTextFieldDelegate {
	
	@IBOutlet weak var cardNumberTextField: CardNumberTextField?
	...
	
	func viewDidLoad() {
		cardNumberTextField?.cardTypeRegister.registerCardType(MyCardType())
	}
	
	...
}
```

#### Customizing the text field appearance

CardNumberTextField is mostly customizable like every other UITextField. Setting any of the following standard attributes for a CardNumberTextField will affect the text field just like it affects any other UITextField:

- **placeholder** (will be automatically formatted at runtime to look like an actual Visa card number, so entering any 16 digits will look authentic.)
- **textColor**
- **backgroundColor**
- **font**
- **keyboardType**
- **secureTextEntry**
- **keyboardAppearance**
- **borderStyle**

Additionally, CardNumberTextField offers attributes tailored to its purpose (accessible from interface builder as well):

- **cardNumberSeparator**: A string that is used to separate the groups in a card number. Defaults to " - ".
- **viewAnimationDuration**: The duration for a view animation in seconds when switching between the card number text field and details (month, view and cvc text fields).
- **invalidInputColor**: The text color for invalid input. When entering an invalid card number, the text will flash in this color and in case of an expired card, the expiry will be displayed in this color as well.

## Author

Daniel Vancura, daniel@prolificinteractive.com

## License

Caishen is available under the MIT license. See the LICENSE file for more info.
