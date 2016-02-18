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
    
    public private(set) var registeredCardTypes: [String:CardType]
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
            AmexCardType().cardTypeName():          AmexCardType(),
            DinersClubCardType().cardTypeName():    DinersClubCardType(),
            DiscoverCardType().cardTypeName():      DiscoverCardType(),
            JCBCardType().cardTypeName():           JCBCardType(),
            MasterCardCardType().cardTypeName():    MasterCardCardType(),
            VisaCardType().cardTypeName():          VisaCardType()
        ]
    }
    
    public func registerCardType(cardType: CardType) {
        registeredCardTypes[cardType.cardTypeName()] = cardType
    }
    
    public func unregisterCardType(cardType: CardType) {
        registeredCardTypes.removeValueForKey(cardType.cardTypeName())
    }
    
    public func setRegisteredCardTypes<Seq: SequenceType where Seq.Generator.Element == CardType>(newRegisteredCardTypes: Seq) {
        registeredCardTypes = [:]
        
        newRegisteredCardTypes.forEach({
            registeredCardTypes[$0.cardTypeName()] = $0
        })
    }
    
    public func cardTypeForNumber(cardNumber: CardNumber) -> CardType? {
        for i in (0...min(cardNumber.stringValue().length(), 6)).reverse() {
            if let substring = cardNumber.stringValue()[0,i], let substringAsNumber = Int(substring) {
                if let firstMatchingCardType = registeredCardTypes.values.filter({
                    $0.cardDigitsIdentifyingCardType().contains(substringAsNumber)
                }).first {
                    return firstMatchingCardType
                }
            }
        }
        
        return nil
    }
}