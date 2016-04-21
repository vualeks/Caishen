//
//  CardCVCValidatorTests.swift
//  Caishen
//
//  Created by Daniel Vancura on 2/3/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import XCTest
import Caishen

class CardCVCValidatorTests: XCTestCase {
    
    func testValidateLength() {
        let validObject = CVC(rawValue: "356")
        let invalidLengthObject1 = CVC(rawValue: "23")
        let invalidLengthObject2 = CVC(rawValue: "2345")
        
        XCTAssertValid(Visa().validateCVC(validObject))
        XCTAssertValid(AmericanExpress().validateCVC(invalidLengthObject2))
        XCTAssertIncompleteCVC(AmericanExpress().validateCVC(validObject))
        XCTAssertIncompleteCVC(Visa().validateCVC(invalidLengthObject1))
        XCTAssertInvalidCVC(Visa().validateCVC(invalidLengthObject2))
    }
    
    func testValidateCharacters() {
        let validObject = CVC(rawValue: "356")
        let invalidCharacterObject1 = CVC(rawValue: "23a")
        let invalidCharacterObject2 = CVC(rawValue: "2.5")
        
        XCTAssertValid(Visa().validateCVC(validObject))
        XCTAssertInvalidCVC(Visa().validateCVC(invalidCharacterObject1))
        XCTAssertInvalidCVC(Visa().validateCVC(invalidCharacterObject2))
    }
    
}
