//
//  ChinaUnionPay.swift
//  Pods
//
//  Created by Shiyuan Jiang on 3/30/16.
//
//

import UIKit

public struct ChinaUnionPay: CardType {
    
    public let name = "ChinaUnionPay"
    
    public let CVCLength = 3
    
    public let identifyingDigits = Set([62])
    
    public init() {
        
    }
    
}
