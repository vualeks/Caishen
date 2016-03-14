//
//  CustomCardNumberTextField.swift
//  Caishen
//
//  Created by Daniel Vancura on 2/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Caishen

class CustomCardNumberTextField: CardNumberTextField {

    override func getNibName() -> String {
        return "CustomTextField"
    }
    
    override func getNibBundle() -> NSBundle {
        return NSBundle.mainBundle()
    }

}
