//
//  StylizedTextField.swift
//  Pods
//
//  Created by Daniel Vancura on 2/10/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

@IBDesignable
public class StylizedTextField: UITextField, UITextFieldDelegate {
    
    /**
     Changes to this parameter draw the border of `self` in the given width.
     */
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet {
            if borderWidth >= 0 {
                self.borderStyle = .None
                self.layer.borderWidth = CGFloat(borderWidth)
            } else {
                self.borderStyle = .RoundedRect
                self.layer.borderWidth = 0
            }
        }
    }
    
    /**
     If `borderWidth` has been set, changes to this parameter round the corners of `self` in the given corner radius.
     */
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            if cornerRadius >= 0 {
                self.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    /**
     If `borderWidth` has been set, changes to this parameter change the color of the border of `self`.
     */
    @IBInspectable
    public var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            self.layer.borderColor = self.borderColor.CGColor
        }
    }
    
    /**
     A method which will be called, when the delete key has been pressed for an empty text field.
     */
    public var deleteBackwardCallback: ((UITextField) -> Void)?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
    }
    
    internal func customDeleteBackward() {
        if (text ?? "").isEmpty {
            deleteBackwardCallback?(self)
        }
        
        super.deleteBackward()
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
