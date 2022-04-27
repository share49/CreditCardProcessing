//
//  InputDataHelper.swift
//  CreditCardProcessing
//

import Foundation

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
