//
//  CardNumberTextFieldDelegate.swift
//  Pods
//
//  Created by Daniel Vancura on 2/28/16.
//
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
    
    func cardNumberTextFieldShouldShowAccessoryImage(cardNumberTextField: CardNumberTextField) -> UIImage?
    
    func cardNumberTextFieldShouldProvideAccessoryAction(cardNumberTextField: CardNumberTextField) -> (() -> ())?
}