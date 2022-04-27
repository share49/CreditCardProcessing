//
//  CreditCardsManagerTests.swift
//  CreditCardProcessingTests
//

import XCTest
@testable import CreditCardProcessing

final class CreditCardsManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var creditCardsManager: CreditCardsManager!
    private let creditCard = CreditCard(givenName: "Lisa", cardNumber: "5454545454545454", limit: 3000)
    
    // MARK: - setUp and tearDown
    override func setUp() {
        super.setUp()
        
        creditCardsManager = CreditCardsManager()
    }
    
    override func tearDown() {
        creditCardsManager = nil
        super.tearDown()
    }
    
    // MARK: - Test input methods
    
    func testAddCreditCard() {
        creditCardsManager.addCreditCard(creditCard)
        XCTAssert(creditCardsManager.creditCards.contains(creditCard))
    }
    
    func testIncreaseBalance() {
        let increasedAmount = 300
        creditCardsManager.addCreditCard(creditCard)
        creditCardsManager.increaseBalance(of: creditCard.givenName, amount: increasedAmount)
        
        let newBalance = creditCardsManager.creditCards.first { $0.givenName == creditCard.givenName }!.balance
        XCTAssertEqual(newBalance, increasedAmount)
    }
    
    func testDecreaseBalance() {
        let decreasedAmount = 300
        creditCardsManager.addCreditCard(creditCard)
        creditCardsManager.decreaseBalance(of: creditCard.givenName, amount: decreasedAmount)
        
        let newBalance = creditCardsManager.creditCards.first { $0.givenName == creditCard.givenName }!.balance
        XCTAssertEqual(newBalance, -decreasedAmount)
    }
    
    // MARK: - Test output methods
    
    func testDisplaySummaryInformation() {
        let amount = 12
        
        // Valid card number
        creditCardsManager.addCreditCard(creditCard)
        creditCardsManager.increaseBalance(of: creditCard.givenName, amount: amount)
        
        // Invalid card number
        let quincysCreditCard = CreditCard(givenName: "Quincy", cardNumber: "1234567890123456", limit: 2000)
        creditCardsManager.addCreditCard(quincysCreditCard)
        
        let output = creditCardsManager.getSummaryInformation()
        let expectedOutput = """
                             ```
                             Lisa: $\(amount)
                             Quincy: error
                             ```
                             """
        XCTAssertEqual(output, expectedOutput)
    }
}
