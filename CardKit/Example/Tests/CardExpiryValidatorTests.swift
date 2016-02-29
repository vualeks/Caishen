//
//  CardExpiryValidatorTests.swift
//  CardKit
//
//  Created by Daniel Vancura on 2/3/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import XCTest
import CardKit

class CardExpiryValidatorTests: XCTestCase {
    
    var validator: CardExpiryDateValidator!

    override func setUp() {
        super.setUp()
        
        self.validator = CardExpiryDateValidator()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDateBeforeNow() {
        let lastYear = CardExpiry(month: 01, year: 2015)
        let future = CardExpiry(month: 12, year: 2115)
        
        XCTAssertValid(validator.validateExpiry(future))
        XCTAssertCardExpired(validator.validateExpiry(lastYear))
    }
    
    func testInvalidExpiryCreation() {
        let shouldBeNil = [     CardExpiry(month: "Feb", year: "2016"), // 0
                                CardExpiry(string: "02/01/2016"), // 1
                                CardExpiry(string: "2016"), // 2
                                CardExpiry(month: "13", year: "2016"), // 3
                                CardExpiry(month: "13", year: "16"), // 4
                                CardExpiry(string: "13/2016"), // 5
                                CardExpiry(string: "13/16"), // 6
                                CardExpiry(string: "02 2016"), // 7
                                CardExpiry(string: "Feb 2016"), // 8
                                CardExpiry(string: "Feb/2016"), // 9
                                CardExpiry(string: "022016"), // 10
                                CardExpiry(string: "02.2016")] // 11
        
        let shouldNotBeNil = [  CardExpiry(string: "02-2006"),
                                CardExpiry(string: "02-06"),
                                CardExpiry(string: "02/06"),
                                CardExpiry(string: "02/2006")]
        
        let shouldNotBeNilAndValid = [  CardExpiry(string: "02-2096"),
                                        CardExpiry(string: "02-96"),
                                        CardExpiry(string: "02/96"),
                                        CardExpiry(string: "02/2096")]
        
        for i in 0..<shouldBeNil.count {
            let obj = shouldBeNil[i]
            XCTAssertNil(obj, "Object \(i) should be nil, but is \(obj?.stringValue())")
        }
        
        for i in 0..<shouldNotBeNil.count {
            let obj = shouldNotBeNil[i]
            XCTAssertNotNil(obj, "Object \(i) should not be nil, but is")
            XCTAssertEqual(obj?.stringValue(), "02/2006")
            if let obj = obj {
                XCTAssertCardExpired(validator.validateExpiry(obj))
            }
        }
        
        for i in 0..<shouldNotBeNilAndValid.count {
            let obj = shouldNotBeNilAndValid[i]
            XCTAssertNotNil(obj, "Object \(i) should not be nil, but is")
            XCTAssertEqual(obj?.stringValue(), "02/2096")
            if let obj = obj {
                XCTAssertCardNotExpired(validator.validateExpiry(obj))
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
