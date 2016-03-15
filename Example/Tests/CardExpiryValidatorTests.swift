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
        
        validator = CardExpiryDateValidator()
    }

    func testDateBeforeNow() {
        let lastYear = Expiry(month: 01, year: 2015)
        let future = Expiry(month: 12, year: 2115)
        
        XCTAssertValid(validator.validateExpiry(future))
        XCTAssertCardExpired(validator.validateExpiry(lastYear))
    }
    
    func testInvalidExpiryCreation() {
        let shouldBeNil = [     Expiry(month: "Feb", year: "2016"), // 0
                                Expiry(string: "02/01/2016"), // 1
                                Expiry(string: "2016"), // 2
                                Expiry(month: "13", year: "2016"), // 3
                                Expiry(month: "13", year: "16"), // 4
                                Expiry(string: "13/2016"), // 5
                                Expiry(string: "13/16"), // 6
                                Expiry(string: "02 2016"), // 7
                                Expiry(string: "Feb 2016"), // 8
                                Expiry(string: "Feb/2016"), // 9
                                Expiry(string: "022016"), // 10
                                Expiry(string: "02.2016")] // 11
        
        let shouldNotBeNil = [  Expiry(string: "02-2006"),
                                Expiry(string: "02-06"),
                                Expiry(string: "02/06"),
                                Expiry(string: "02/2006")]
        
        let shouldNotBeNilAndValid = [  Expiry(string: "02-2096"),
                                        Expiry(string: "02-96"),
                                        Expiry(string: "02/96"),
                                        Expiry(string: "02/2096")]
        
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

}
