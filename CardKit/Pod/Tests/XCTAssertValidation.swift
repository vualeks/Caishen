//
//  XCTAssertValidation.swift
//  Pods
//
//  Created by Daniel Vancura on 2/3/16.
//
//

import UIKit
import CardKit
import XCTest

func XCTAssertValid(validationResult: CardValidationResult) {
    XCTAssertTrue(validationResult == CardValidationResult.Valid)
}

func XCTAssertInvalidCVC(validationResult: CardValidationResult) {
    XCTAssertTrue(validationResult.isSupersetOf(CardValidationResult.InvalidCVC))
}

func XCTAssertInvalidNumberForType(validationResult: CardValidationResult) {
    XCTAssertTrue(validationResult.isSupersetOf(CardValidationResult.NumberDoesNotMatchType))
}
