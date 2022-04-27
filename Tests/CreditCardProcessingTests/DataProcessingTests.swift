//
//  DataProcessingTests.swift
//  CreditCardProcessingTests
//

import XCTest
@testable import CreditCardProcessing

final class DataProcessingTests: XCTestCase {
    
    // MARK: - Properties
    
    let expectedResult = ["Add Tom 4111111111111111 $1000", "Add Lisa 5454545454545454 $3000"]
    
    // MARK: - Tests
    
    func testProcessInputData() {
        let inputData = """
                        ```
                        Add Tom 4111111111111111 $1000
                        Add Lisa 5454545454545454 $3000
                        Add Quincy 1234567890123456 $2000
                        Charge Tom $500
                        Charge Tom $800
                        Charge Lisa $7
                        Credit Lisa $100
                        Credit Quincy $200
                        ```
                        """
        let output = processInputData(inputData)
        
        let expectedOutput = """
                             ```
                             Lisa: $-93
                             Quincy: error
                             Tom: $500
                             ```
                             """
        
        XCTAssertEqual(output, expectedOutput)
    }
}
