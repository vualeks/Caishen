//
//  CardTypeRegister.swift
//  Pods
//
//  Created by Daniel Vancura on 2/17/16.
//
//

import UIKit

private var onceToken: dispatch_once_t = 0
private var sharedRegister: CardTypeRegister!

public class CardTypeRegister {
    
    public private(set) var registeredCardTypes: [CardType.Type]
    public static var sharedCardTypeRegister: CardTypeRegister {
        dispatch_once(&onceToken, {
            sharedRegister = CardTypeRegister()
        })
        
        return sharedRegister
    }
    private var cardNumbersIdentifyingCardTypes: Set<Int>
    
    public init() {
        cardNumbersIdentifyingCardTypes = Set()
        registeredCardTypes = [
            AmexCardType.self,
            DinersClubCardType.self,
            DiscoverCardType.self,
            JCBCardType.self,
            MasterCardCardType.self,
            VisaCardType.self
        ]
    }
    
    public func registerCardType(cardType: CardType.Type) {
        if registeredCardTypes.contains({$0 == cardType}) {
            return
        }
        registeredCardTypes.append(cardType)
    }
    
    public func unregisterCardType(cardType: CardType.Type) {
        registeredCardTypes = registeredCardTypes.filter({$0 != cardType})
    }
    
    public func setRegisteredCardTypes<Seq: SequenceType where Seq.Generator.Element == CardType.Type>(newRegisteredCardTypes: Seq) {
        registeredCardTypes = []
        
        newRegisteredCardTypes.forEach({
            registeredCardTypes.append($0)
        })
    }
    
    public func cardTypeForNumber(cardNumber: CardNumber) -> CardType.Type? {
        for i in (0...min(cardNumber.stringValue().length(), 6)).reverse() {
            if let substring = cardNumber.stringValue()[0,i], let substringAsNumber = Int(substring) {
                if let firstMatchingCardType = registeredCardTypes.filter({
                    $0.cardDigitsIdentifyingCardType().contains(substringAsNumber)
                }).first {
                    return firstMatchingCardType
                }
            }
        }
        
        return nil
    }
}