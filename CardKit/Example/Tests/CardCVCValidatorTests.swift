//
//  CardCVCValidatorTests.swift
//  Pods
//
//  Created by Daniel Vancura on 2/3/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import XCTest
import CardKit

class CardCVCValidatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidateLength() {
        let validObject = CardCVC(string: "356")
        let invalidLengthObject1 = CardCVC(string: "23")
        let invalidLengthObject2 = CardCVC(string: "2345")
        
        XCTAssertValid(VisaCardType().validateCVC(validObject))
        XCTAssertValid(AmexCardType().validateCVC(invalidLengthObject2))
        XCTAssertIncompleteCVC(AmexCardType().validateCVC(validObject))
        XCTAssertIncompleteCVC(VisaCardType().validateCVC(invalidLengthObject1))
        XCTAssertInvalidCVC(VisaCardType().validateCVC(invalidLengthObject2))
    }
    
    func testValidateCharacters() {
        let validObject = CardCVC(string: "356")
        let invalidCharacterObject1 = CardCVC(string: "23a")
        let invalidCharacterObject2 = CardCVC(string: "2.5")
        
        XCTAssertValid(VisaCardType().validateCVC(validObject))
        XCTAssertInvalidCVC(VisaCardType().validateCVC(invalidCharacterObject1))
        XCTAssertInvalidCVC(VisaCardType().validateCVC(invalidCharacterObject2))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
