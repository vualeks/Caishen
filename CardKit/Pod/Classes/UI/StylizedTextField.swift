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
    public var deleteBackwardCallback: ((UITextField) -> Void)?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
    }
    
    public override func deleteBackward() {
        super.deleteBackward()
        
        if (text ?? "").isEmpty {
            deleteBackwardCallback?(self)
        }
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
