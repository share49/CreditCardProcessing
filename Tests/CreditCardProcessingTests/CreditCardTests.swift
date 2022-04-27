//
//  CreditCardTests.swift
//  CreditCardProcessingTests
//

import XCTest
@testable import CreditCardProcessing

final class CreditCardTests: XCTestCase {
    
    private let givenName = "Lisa"
    private let cardNumber = "5454545454545454"
    private let invalidCardNumber = "5454545454545453"
    private let limit = 3000
    
    // MARK: Add credit card
    
    func testAddCreditCard() {
        let creditCard = CreditCard(givenName: givenName, cardNumber: cardNumber, limit: limit)
        XCTAssertEqual(creditCard.givenName, givenName)
        XCTAssertEqual(creditCard.cardNumber, cardNumber)
        XCTAssertEqual(creditCard.limit, limit)
        XCTAssertEqual(creditCard.balance, 0)
        XCTAssertEqual(creditCard.isValidated, true)
        
        let invalidCreditCard = CreditCard(givenName: givenName, cardNumber: invalidCardNumber, limit: limit)
        XCTAssertEqual(invalidCreditCard.isValidated, false)
    }
    
    // MARK: Increase balance
    
    func testIncreaseCreditCardToTheBalanceLimit() {
        let creditCard = CreditCard(givenName: givenName, cardNumber: cardNumber, limit: limit)
        creditCard.increaseBalance(by: limit)

        XCTAssertEqual(creditCard.balance, limit)
    }
    
    func testIncreaseCreditCardAboveTheBalanceLimit() {
        let creditCard = CreditCard(givenName: givenName, cardNumber: cardNumber, limit: limit)
        creditCard.increaseBalance(by: limit + 1)
        
        XCTAssertEqual(creditCard.balance, 0)
    }
    
    func testIncreaseInvalidCreditCard() {
        let invalidCreditCard = CreditCard(givenName: givenName, cardNumber: invalidCardNumber, limit: limit)
        invalidCreditCard.increaseBalance(by: 1)
        
        XCTAssertEqual(invalidCreditCard.balance, 0)
    }

    // MARK: Decrease balance

    func testDecreaseCreditCard() {
        let creditCard = CreditCard(givenName: givenName, cardNumber: cardNumber, limit: limit)
        creditCard.decreaseBalance(by: 1)
        
        XCTAssertEqual(creditCard.balance, -1)
    }
    
    func testDecreaseInvalidCreditCard() {
        let invalidCreditCard = CreditCard(givenName: givenName, cardNumber: invalidCardNumber, limit: limit)
        invalidCreditCard.decreaseBalance(by: 1)
        
        XCTAssertEqual(invalidCreditCard.balance, 0)
    }
}
