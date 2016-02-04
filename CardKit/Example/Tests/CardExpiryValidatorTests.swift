//
//  CardExpiryValidatorTests.swift
//  CardKit
//
//  Created by Daniel Vancura on 2/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
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
        let shouldBeNil = [ CardExpiry(month: "Feb", year: "2016"),
                            CardExpiry(string: "02/01/2016"),
                            CardExpiry(string: "2016"),
                            CardExpiry(month: "13", year: "2016"),
                            CardExpiry(string: "13/2016") ]
        let shouldNotBeNil = [  CardExpiry(string: "02 2016"),
                                CardExpiry(string: "02/2016"),
                                CardExpiry(string: "Feb 2016"),
                                CardExpiry(string: "Feb/2016") ]
        
        for i in 0..<shouldBeNil.count {
            let obj = shouldBeNil[i]
            XCTAssertNil(obj, "Object \(i) should be nil, but is \(obj?.stringValue())")
        }
        
        for i in 0..<shouldNotBeNil.count {
            let obj = shouldNotBeNil[i]
            XCTAssertNotNil(obj, "Object \(i) should not be nil, but is")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
