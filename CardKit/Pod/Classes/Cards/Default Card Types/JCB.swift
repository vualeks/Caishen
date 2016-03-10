//
//  JCB.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

public struct JCB: CardType {
    
    public let cardTypeImage: UIImage? = UIImage(named: "JCB") ?? UIImage(named: "JCB", inBundle: NSBundle(forClass: CardNumberTextField.self), compatibleWithTraitCollection: nil)
    
    public let name = "JCB"
    
    public let CVCLength = 3
    
    public let identifyingDigits = Set(3528...3589).union(Set([3088, 3096, 3112, 3158, 3337]) )

    public init() {
        
    }

}