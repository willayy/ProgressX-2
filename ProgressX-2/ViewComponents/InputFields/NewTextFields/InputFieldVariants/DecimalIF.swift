//
//  DecimalIF.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-09-29.
//

import SwiftUI

public class DecimalIF: NumericInputFieldVariant {
    
    public init(
        
        min: Double,
        max: Double,
        bwButton: Bool,
        allowNeg: Bool,
        optional: Bool
        
    ) {
        
        super.init(
            minScaleFactor: 0.75,
            maxChars: 7,
            allowEmpty: optional,
            bwButton: bwButton,
            allowNegatives: allowNeg,
            max: max,
            min: min
        )
        
    }
    
    override internal func filterInput(_ new: String) -> String {
        
        // Filter out non allowed characters
        var filtered = new
            .replacingOccurrences(of: ",", with: ".")
            .filter { allowedChars.contains($0) }
        
        // Ensure first char isnt a dot, last char is handled in submit
        if filtered.first == "." {
            filtered.removeFirst()
        }
        
        // Ensure that number isnt longer than max chars
        if filtered.count > maxChars {
            filtered.removeLast()
        }
        
        // Ensure minus is only at the beginning
        if filtered.contains("-") && filtered.first != "-" {
            filtered.removeAll(where: { $0 == "-" })
        }
        
        // Find out of many dots there are
        let dotAmount = filtered.filter { $0 == "." }.count
        
        // If more than one dot remove last one
        if dotAmount > 1 {
            let i = filtered.lastIndex(of: ".")!
            filtered.remove(at: i)
        }
        
        return filtered
            
    }
    
    override internal func dynamicValidation(_ filtered: String) -> Bool {
        
        // Reset error message
        self.errorMessage = ""
        
        // if the field is empty let it pass the dynamic validation
        if filtered.isEmpty {
            
            return true
            
        }
        
        // Check that input is a number
        guard let numericalValue: Double = Double(filtered) else {
            
            withAnimation { self.errorMessage = "Entered value is not a valid number" }
            
            return false
            
        }
        
        // Check that input isn't too big
        if numericalValue > self.max {
            
            withAnimation { self.errorMessage = "Entered value is too big" }
            
            return false
            
        }
        
        // CHeck that input isn't too small.
        if numericalValue < self.min {
            
            withAnimation { self.errorMessage = "Entered value is too small" }
            
            return false
            
        }
        
        return true
        
    }
    
}
