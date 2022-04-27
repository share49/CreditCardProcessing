//
//  DataProcessing.swift
//  CreditCardProcessing
//

import Foundation

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
