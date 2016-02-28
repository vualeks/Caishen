//
//  CardNumberTextFieldDelegate.swift
//  Pods
//
//  Created by Daniel Vancura on 2/28/16.
//
//

import Foundation

public protocol CardNumberTextFieldDelegate {
    
    func cardNumberTextField(cardNumberTextField: CardNumberTextField, didEnterCardInformation information: Card?, withValidationResult validationResult: CardValidationResult?)
}