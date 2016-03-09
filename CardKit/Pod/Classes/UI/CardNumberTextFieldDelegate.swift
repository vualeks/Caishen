//
//  CardNumberTextFieldDelegate.swift
//  Pods
//
//  Created by Daniel Vancura on 2/28/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import Foundation

public protocol CardNumberTextFieldDelegate {
    
    /**
     Callback for a CardNumberTextField, which is called whenever the entered Card information has changed.
     - parameter cardNumberTextField: The CardNumberTextField which received an update to its card information.
     - parameter information: The Card information which has been entered in the CardNumberTextField or nil, if one or more of the CardNumberTextField's text fields are empty or incomplete.
     - parameter validationResult: The result for the card validation of `information` or nil, if one or more of the CardNumberTextField's text fields are empty or incomplete.
     */
    func cardNumberTextField(cardNumberTextField: CardNumberTextField, didEnterCardInformation information: Card?, withValidationResult validationResult: CardValidationResult?)
    
    /**
     Callback for a CardNumberTextField, which is called to update the image for its accessory button.
     - parameter cardNumberTextField: The card number text field requesting an image for its accessory button.
     - returns: An image for the cardNumberTextField's accessory button.
     */
    func cardNumberTextFieldShouldShowAccessoryImage(cardNumberTextField: CardNumberTextField) -> UIImage?
    
    /**
     Callback for a CardNumberTextField, which is used to check whether an accessory button should be provided.
     You can provide an arbitrary function which will be assigned to the text field's accessory button or nil, if you do not need an accessory button.
     - parameter cardNumberTextField: The text field requesting an action for its accessory button.
     - returns: Any action that is performed when the accessory button is tapped or nil, if no accessory button should be displayed in the text field.
     */
    func cardNumberTextFieldShouldProvideAccessoryAction(cardNumberTextField: CardNumberTextField) -> (() -> ())?
}