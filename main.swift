#!/usr/bin/env swift

import Foundation

// MARK: - Executable

let fileName = CommandLine.arguments[1]
let fileUrl = URL(fileURLWithPath: fileName)

do {
    let inputData = try String(contentsOf: fileUrl, encoding: .utf8)
    print(processInputData(inputData))
} catch {
    print("Error: \(error)")
}

// MARK: - Source code

/// Helper to process the input data.
final class InputDataHelper {
    
    /// Parse the input data commands for each line break, removing the start and end apostrophes if they are present.
    /// - Parameter inputData: Multiline String of commands.
    /// - Returns: An array of commands.
    static func getCommands(from inputData: String) -> [String] {
        var commands = inputData.components(separatedBy: "\n")
        
        if commands.first == "```" {
            commands.removeFirst()
        }
        
        if commands.last == "```" {
            commands.removeLast()
        }
        
        return commands
    }
    
    /// Removes the currency symbol from the amount and transforms the amount string into an Int.
    /// - Parameter amountString: Amount (e.g. $1000).
    /// - Returns: The amount number as an Int.
    static func getAmountNumber(from amountString: String) -> Int {
        Int(amountString.dropFirst())!
    }
}

fileprivate enum CommandType: String {
    case add
    case charge
    case credit
}

/// Process input String by parsing command lines, handle command actions to Add, Charge or Credit a credit card. Once all the data is processed, it returns a formatted summary.
func processInputData(_ inputData: String) -> String {
    let globalCards = CreditCardsManager()
    
    let commands = InputDataHelper.getCommands(from: inputData)
    commands.forEach { command in
        let commandElements = command.components(separatedBy: " ")
        
        guard let firstElement = commandElements.first?.lowercased(),
              let commandType = CommandType(rawValue: firstElement),
              let lastElement = commandElements.last else {
                  
                  return
              }
        
        let givenName = commandElements[1]
        
        if commandType == .add {
            let cardNumber = commandElements[2]
            let limit = InputDataHelper.getAmountNumber(from: lastElement)
            let creditCard = CreditCard(givenName: givenName, cardNumber: cardNumber, limit: limit)
            globalCards.addCreditCard(creditCard)
            
        } else if commandType == .charge {
            let amount = InputDataHelper.getAmountNumber(from: lastElement)
            globalCards.increaseBalance(of: givenName, amount: amount)
            
        } else if commandType == .credit {
            let amount = InputDataHelper.getAmountNumber(from: lastElement)
            globalCards.decreaseBalance(of: givenName, amount: amount)
        }
    }
    
    return globalCards.getSummaryInformation()
}

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

final class LuhnChecker {
    
    /// Validate card number with Luhn 10.
    /// - Parameter number: Credit card number to validate.
    /// - Returns: Validation result Bool.
    static func validate(_ number: String) -> Bool {
        var sum = 0
        let reversedStringNumber = number.reversed().map { String($0) }
        
        for tuple in reversedStringNumber.enumerated() {
            let odd = tuple.offset % 2 == 1
            let digit = Int(tuple.element)!
            
            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
}
