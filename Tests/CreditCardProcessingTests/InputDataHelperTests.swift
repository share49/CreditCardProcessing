//
//  InputDataHelperTests.swift
//  CreditCardProcessingTests
//

import XCTest
@testable import CreditCardProcessing

final class InputDataHelperTests: XCTestCase {
    
    // MARK: - Properties
    
    let expectedResult = ["Add Tom 4111111111111111 $1000", "Add Lisa 5454545454545454 $3000"]
    
    // MARK: - Tests
    
    func testGetCommandsFromInputDataWithoutApostrophes() {
        let inputData = """
                        \(expectedResult[0])
                        \(expectedResult[1])
                        """
        XCTAssertEqual(InputDataHelper.getCommands(from: inputData), expectedResult)
    }
    
    func testGetCommandsFromInputDataWithEndingApostrophes() {
        let inputData = """
                        \(expectedResult[0])
                        \(expectedResult[1])
                        ```
                        """
        XCTAssertEqual(InputDataHelper.getCommands(from: inputData), expectedResult)
    }
    
    func testGetCommandsFromInputDataWithBeginningApostrophes() {
        let inputData = """
                        ```
                        \(expectedResult[0])
                        \(expectedResult[1])
                        """
        XCTAssertEqual(InputDataHelper.getCommands(from: inputData), expectedResult)
    }
    
    func testGetCommandsFromInputDataWithApostrophes() {
        let inputData = """
                        ```
                        \(expectedResult[0])
                        \(expectedResult[1])
                        ```
                        """
        XCTAssertEqual(InputDataHelper.getCommands(from: inputData), expectedResult)
    }
    
    func testGetAmountNumberFromAmountString() {
        let amount = 1000
        let stringAmount = "$\(amount)"
        XCTAssertEqual(InputDataHelper.getAmountNumber(from: stringAmount), amount)
    }
}
