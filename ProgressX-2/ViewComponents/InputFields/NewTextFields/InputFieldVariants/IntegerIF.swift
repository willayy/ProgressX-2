//
//  IntegerIF.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-07.
//

import Foundation

public class IntegerIF: NumericInputFieldVariant {
    
    public init(
        
        max: Int,
        min: Int,
        allowNeg: Bool,
        optional: Bool
        
    ) {
        
        super.init(
            minScaleFactor: 0.75,
            maxChars: 7,
            allowEmpty: optional,
            bwButton: false,
            allowNegatives: allowNeg,
            max: Double(max),
            min: Double(min)
        )
        
    }
    
    override internal func filterInput(_ new: String) -> String {
        
        // Filter away non-allowed characters.
        var filtered = new
            .replacingOccurrences(of: ",", with: ".")
            .filter { allowedChars.contains($0) }
        
        // Check so the input isn't longer than
        if filtered.count > maxChars {
            filtered.removeLast()
        }
        
        // Ensure minus is only at the beginning
        if filtered.contains("-") && filtered.first != "-" {
            filtered.removeAll(where: { $0 == "-" })
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
        guard let numericalValue: Int = Int(filtered) else {
            
            self.errorMessage = "Entered value is not a valid number"
            
            return false
            
        }
        
        // Check that input isn't too big
        if Double(numericalValue) > self.max {
            
            self.errorMessage = "Entered value is too big"
            
            return false
            
        }
        
        // CHeck that input isn't too small.
        if Double(numericalValue) < self.min {
            
            self.errorMessage = "Entered value is too small"
            
            return false
            
        }
        
        return true
        
    }
    
}
