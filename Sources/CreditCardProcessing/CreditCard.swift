//
//  CreditCard.swift
//  CreditCardProcessing
//

import Foundation

final class CreditCard {
    
    // MARK: - Properties
    
    let givenName: String
    let cardNumber: String
    let limit: Int
    let isValidated: Bool
    private(set) var balance: Int
    
    // MARK: - Initializer
    
    /// Creates a new CreditCard for a given name, card number, and limit.
    /// Card numbers are validated on init using Luhn 10.
    /// CreditCard starts with a 0 balance.
    init(givenName: String, cardNumber: String, limit: Int) {
        self.givenName = givenName
        self.cardNumber = cardNumber
        self.limit = limit
        self.balance = 0
        self.isValidated = LuhnChecker.validate(cardNumber)
    }
    
    // MARK: - Methods
    
    /// Increase the balance by the amount specified if the end balance will be within the CreditCard limit and the card is validated.
    func increaseBalance(by amount: Int) {
        guard (balance + amount) <= limit, isValidated else {
            return
        }
        balance += amount
    }
    
    /// Decrease the balance by the amount specified if the card is validated. Decreasing balance below 0 will create a negative balance.
    func decreaseBalance(by amount: Int) {
        guard isValidated else {
            return
        }
        balance -= amount
    }
}

/// Conforming to Equatable and Hashable to use a Set in CreditCardsManager to have unique credit cards by card number.
extension CreditCard: Equatable, Hashable {
    static func == (lhs: CreditCard, rhs: CreditCard) -> Bool {
        lhs.cardNumber == rhs.cardNumber
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
