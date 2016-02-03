//
//  CardCVCValidatorTests.swift
//  Pods
//
//  Created by Daniel Vancura on 2/3/16.
//
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
        
        XCTAssertValid(self.validator.validateCVC(validObject, forCardType: .CardTypeVisa))
        XCTAssertValid(self.validator.validateCVC(invalidLengthObject2, forCardType: .CardTypeAmex))
        XCTAssertInvalidCVC(self.validator.validateCVC(validObject, forCardType: .CardTypeAmex))
        XCTAssertInvalidCVC(self.validator.validateCVC(invalidLengthObject1, forCardType: .CardTypeVisa))
        XCTAssertInvalidCVC(self.validator.validateCVC(invalidLengthObject2, forCardType: .CardTypeVisa))
    }
    
    func testValidateCharacters() {
        let validObject = CardCVC(string: "356")
        let invalidCharacterObject1 = CardCVC(string: "23a")
        let invalidCharacterObject2 = CardCVC(string: "2.5")
        
        XCTAssertValid(self.validator.validateCVC(validObject, forCardType: .CardTypeVisa))
        XCTAssertInvalidCVC(self.validator.validateCVC(invalidCharacterObject1, forCardType: .CardTypeVisa))
        XCTAssertInvalidCVC(self.validator.validateCVC(invalidCharacterObject2, forCardType: .CardTypeVisa))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
