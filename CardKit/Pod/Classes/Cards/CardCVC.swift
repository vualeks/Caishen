//
//  SPKCardNumber.swift
//  SwiftPaymentKit
//
//  Created by Sagar Natekar on 11/23/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

public class CardCVC {
    private var cvc: String = ""
    
    /**
     Creates a new bank card verification code with the given argument.
     
     - parameter string: The string representation of the CVC.
    */
    public init(string: String) {
        self.cvc = string
    }
    
    public func stringValue() -> String {
        return self.cvc
    }
    
    public func length() -> Int {
        return self.cvc.length()
    }
}
