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
    
    public static var sharedCardTypeRegister: CardTypeRegister {
        dispatch_once(&onceToken, {
            sharedRegister = CardTypeRegister()
        })
        
        return sharedRegister
    }
    
    public private(set) var registeredCardTypes: [String:CardType] = [
        AmexCardType().cardTypeName():          AmexCardType(),
        DinersClubCardType().cardTypeName():    DinersClubCardType(),
        DiscoverCardType().cardTypeName():      DiscoverCardType(),
        JCBCardType().cardTypeName():           JCBCardType(),
        MasterCardCardType().cardTypeName():    MasterCardCardType(),
        VisaCardType().cardTypeName():          VisaCardType()
    ]
    
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
        return registeredCardTypes.values.filter({
            $0.checkCardNumberAgainstCardType(cardNumber)
        }).first
    }
}