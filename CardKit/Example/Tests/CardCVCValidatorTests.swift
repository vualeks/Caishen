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
    
    var validator: CardCVCValidator!
    
    override func setUp() {
        super.setUp()
        
        self.validator = CardCVCValidator()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.validator = nil
        
        super.tearDown()
    }
    
    func testValidateLength() {
        let validObject = CardCVC(string: "356")
        let invalidLengthObject1 = CardCVC(string: "23")
        let invalidLengthObject2 = CardCVC(string: "2345")
        
        XCTAssertValid(self.validator.validateCVC(validObject, forCardType: .Visa))
        XCTAssertValid(self.validator.validateCVC(invalidLengthObject2, forCardType: .Amex))
        XCTAssertIncompleteCVC(self.validator.validateCVC(validObject, forCardType: .Amex))
        XCTAssertIncompleteCVC(self.validator.validateCVC(invalidLengthObject1, forCardType: .Visa))
        XCTAssertInvalidCVC(self.validator.validateCVC(invalidLengthObject2, forCardType: .Visa))
    }
    
    func testValidateCharacters() {
        let validObject = CardCVC(string: "356")
        let invalidCharacterObject1 = CardCVC(string: "23a")
        let invalidCharacterObject2 = CardCVC(string: "2.5")
        
        XCTAssertValid(self.validator.validateCVC(validObject, forCardType: .Visa))
        XCTAssertInvalidCVC(self.validator.validateCVC(invalidCharacterObject1, forCardType: .Visa))
        XCTAssertInvalidCVC(self.validator.validateCVC(invalidCharacterObject2, forCardType: .Visa))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
