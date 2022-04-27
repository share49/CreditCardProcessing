//
//  LuhnChecker.swift
//  CreditCardProcessing
//

import Foundation

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
