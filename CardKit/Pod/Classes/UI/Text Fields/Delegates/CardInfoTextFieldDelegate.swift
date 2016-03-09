//
//  MonthInputTextFieldDelegate.swift
//  Pods
//
//  Created by Daniel Vancura on 3/8/16.
//
//

import UIKit

public protocol CardInfoTextFieldDelegate {
    func textField(textField: UITextField, didEnterValidInfo: String)
    
    func textField(textField: UITextField, didEnterInvalidInfo: String)
}
