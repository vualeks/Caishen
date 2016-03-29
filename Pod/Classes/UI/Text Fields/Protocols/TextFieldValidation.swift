//
//  TextFieldValidation.swift
//  Pods
//
//  Created by Daniel Vancura on 3/29/16.
//
//

import Foundation

internal protocol TextFieldValidation {
    
    /**
     Default number of expected digits for MonthInputTextField and YearInputTextField
     */
    var expectedInputLength: Int { get }
    
    /**
     Checks the validity of the input.
     
     - returns: True, if the input is valid.
     */
    func isInputValid(input: String, partiallyValid: Bool) -> Bool
}