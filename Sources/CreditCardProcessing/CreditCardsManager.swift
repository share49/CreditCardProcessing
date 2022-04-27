//
//  CreditCardsManager.swift
//  CreditCardProcessing
//

import Foundation

final class CreditCardsManager {
    
    // MARK: - Properties
    
    private(set) var creditCards = Set<CreditCard>()
    
    // MARK: - Input methods
    
    /// Add a new CreditCard to the CreditCardsManager.
    func addCreditCard(_ creditCard: CreditCard) {
        creditCards.insert(creditCard)
    }
    
    /// Increase the balance of the card associated with the given name by the amount specified.
    /// - Parameters:
    ///   - givenName: Credit card holder given name.
    ///   - amount: Amount by which the balance will be increased.
    func increaseBalance(of givenName: String, amount: Int) {
        creditCards.first { $0.givenName == givenName }?.increaseBalance(by: amount)
    }
    
    /// Decrease the balance of the card associated with the given name by the amount specified.
    /// - Parameters:
    ///   - givenName: Credit card holder given name.
    ///   - amount: Amount by which the balance will be decreased.
    func decreaseBalance(of givenName: String, amount: Int) {
        creditCards.first { $0.givenName == givenName }?.decreaseBalance(by: amount)
    }
    
    // MARK: - Output methods
    
    /// Get credit cards summary sorted by given name and containing the holder's given name and the balance. Balance will display error if credit card number validation fails.
    func getSummaryInformation() -> String {
        let sortedCreditCards = Array(creditCards).sorted { $0.givenName < $1.givenName }
        
        var creditCardsSummary = "```\n"
        
        for creditCard in sortedCreditCards {
            let givenName = creditCard.givenName
            let balance = creditCard.isValidated ? "$\(creditCard.balance)" : "error"
            let summaryLine = "\(givenName): \(balance)\n"
            creditCardsSummary.append(contentsOf: summaryLine)
        }
        
        creditCardsSummary.append("```")

        return creditCardsSummary
    }
}
