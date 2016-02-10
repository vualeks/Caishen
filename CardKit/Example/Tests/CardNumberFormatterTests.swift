//
//  CardNumberFormatterTests.swift
//  CardKit
//
//  Created by Daniel Vancura on 2/9/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import CardKit

class CardNumberFormatterTests: XCTestCase {
    
    private var formatter: CardNumberFormatter!
    
    override func setUp() {
        super.setUp()
        
        self.formatter = CardNumberFormatter()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCorrectSeparator() {
        self.formatter.separator = "-"
        
        let testNumber = CardNumber(string: "4123123412341234")
        
        let formattedTestNumber = self.formatter.formattedCardNumber(testNumber.stringValue(), forCardType: CardType.CardTypeForNumber(testNumber))
        
        XCTAssertEqual(formattedTestNumber, "4123-1234-1234-1234")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
