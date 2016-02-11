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
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            if cornerRadius >= 0 {
                self.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            self.layer.borderColor = self.borderColor.CGColor
        }
    }
    
    @IBInspectable
    public var leftViewBackgroundColor: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.0) {
        didSet {
            self.leftView?.backgroundColor = leftViewBackgroundColor
        }
    }
    
    @IBInspectable
    public var rightViewBackgroundColor: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.0) {
        didSet {
            self.rightView?.backgroundColor = rightViewBackgroundColor
        }
    }
    
    @IBInspectable
    public var leftViewWidth: CGFloat = 30 {
        didSet {
            self.leftView?.frame = self.bounds
            self.leftView?.frame.size.width = leftViewWidth
        }
    }
    
    @IBInspectable
    public var rightViewWidth: CGFloat = 30 {
        didSet {
            self.rightView?.frame = self.bounds
            self.rightView?.frame.size.width = self.rightViewWidth
        }
    }
    
    /**
     The view that is displayed next to the card number text field.
     */
    public override var leftView: UIView? {
        set {
            super.leftView = newValue
            if let _ = newValue {
                super.leftViewMode = .Always
            } else {
                super.leftViewMode = .Never
            }
        }
        get {
            return super.leftView
        }
    }
    
    /**
     The view that is displayed next to the card number text field.
     */
    public override var rightView: UIView? {
        set {
            super.rightView = newValue
            if let _ = newValue {
                super.rightViewMode = .Always
            } else {
                super.rightViewMode = .Never
            }
        }
        get {
            return super.rightView
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.postInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        self.postInit()
    }
    
    internal func postInit() {
        self.leftViewWidth = self.leftViewWidth + 0
        self.rightViewWidth = self.rightViewWidth + 0
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
