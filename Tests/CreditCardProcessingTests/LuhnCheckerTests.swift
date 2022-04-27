//
//  LuhnCheckerTests.swift
//  CreditCardProcessingTests
//

import XCTest
@testable import CreditCardProcessing

final class LuhnCheckerTests: XCTestCase {
    
    func testValidateLuhnNumber() {
        XCTAssertTrue(LuhnChecker.validate("4111111111111111"))
        XCTAssertFalse(LuhnChecker.validate("4111111131111111"))

        XCTAssertTrue(LuhnChecker.validate("1234567890159456"))
        XCTAssertFalse(LuhnChecker.validate("1234567890123456"))

        XCTAssertTrue(LuhnChecker.validate("5454545454545454"))
        XCTAssertFalse(LuhnChecker.validate("5454545455545454"))

        XCTAssertTrue(LuhnChecker.validate("79927398713"))
        XCTAssertFalse(LuhnChecker.validate("79927389713"))
    }
}
