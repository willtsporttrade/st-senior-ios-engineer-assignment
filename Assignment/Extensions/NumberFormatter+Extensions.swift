//
//  NumberFormatter+Extensions.swift
//  Assignment
//
//  Created by Dougherty, Keith on 9/29/21.
//

import Foundation

extension NumberFormatter {
    /**
    Returns number formatter suitable for displaying US currency.
    */
    /**
    Number formatter suitable for displaying up to US Currency.
     
     - Parameters:
            - number: NSDecimalNumber to be formatted
     
     - Returns: String representation of the decimal number as US Curreny
    */
    func formatUSCurrency(for number:NSDecimalNumber) -> String {
        self.locale = Locale(identifier: "en-us")
        self.numberStyle = .currency
        return self.string(from: number as NSNumber) ?? ""
    }
    
    /**
    Number formatter suitable for displaying up to 4 decimal places.
     
     - Parameters:
            - number: NSDecimalNumber to be formatted
     
     - Returns: String representation of the decimal number truncated to a max
            of 4 decimal places
    */
    func formatToMax4Decimal(for number:NSDecimalNumber) -> String {
        self.numberStyle = .decimal
        self.maximumFractionDigits = 4
        return self.string(from: number as NSNumber) ?? ""
    }
}
