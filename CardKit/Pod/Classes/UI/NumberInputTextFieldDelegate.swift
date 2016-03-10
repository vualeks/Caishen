//
//  CardNumberInputTextFieldDelegate.swift
//  Pods
//
//  Created by Daniel Vancura on 2/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

/**
 The delegate protocol for a `CardNumberInputTextField`. The delegate gets notified about changes to the text, as well as an update, if a valid card number has been entered.
 */
@objc
public protocol NumberInputTextFieldDelegate {
    /**
     Called by `cardNumberTextField` when the user entered a valid card number.
     
     - parameter cardNumberTextField: The CardNumberTextField that was used by the user to enter a card number.
     - parameter cardNumber: The card number the user entered.
     */
    func numberInputTextFieldDidComplete(cardNumberTextField: NumberInputTextField)
    
    func numberInputTextFieldDidChangeText(cardNumberTextField: NumberInputTextField)
}
