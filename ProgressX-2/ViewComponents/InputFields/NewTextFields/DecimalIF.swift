//
//  DecimalIF.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-09-29.
//

public class DecimalIF: InputFieldVariant {
    
    static private let allowedChars: Set<Character> = [
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        ".",
        ","
    ]
    
    private let max: Double
    
    private let min: Double
    
    init(min: Double, max: Double, optional: Bool) {
        
        self.max = max
        self.min = min
        
        super.init(
            allowedChars: DecimalIF.allowedChars,
            keyBoardType: .numbersAndPunctuation,
            minScaleFactor: 0.75,
            maxChars: 7,
            allowEmpty: optional
        )
        
    }
    
    override public func filterInput(_ new: String) -> String {
        
        // Filter out non allowed characters
        var filtered = new.filter {
            allowedChars.contains($0)
        }
        
        // Ensure first char isnt a dot, last char is handled in submit
        if filtered.first == "." {
            filtered.removeFirst()
        }
        
        // Ensure that number isnt longer than max chars
        if new.count > maxChars {
            filtered.removeLast()
        }
        
        // Ensure minus is only at the beginning
        if new.contains("-") && new.first != "-" {
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
    
    override public func onChange(_ new: String) -> String {
        
        // Always convert , to .
        return new.replacingOccurrences(of: ",", with: ".")
        
    }
    
    override public func isValid(_ new: String) -> Bool {
        
        // Reset error message
        self.errorMessage = ""
        
        if new.isEmpty && self.allowEmpty {
            return true
        }
        
        // Check that input is a number
        guard let numericalValue: Double = Double(new) else {
            
            self.errorMessage = "Entered value is not a valid number"
            
            return false
            
        }
        
        // Check that input isn't too big
        if numericalValue > self.max {
            
            self.errorMessage = "Entered value is too big"
            
            return false
            
        }
        
        // CHeck that input isn't too small.
        if numericalValue < self.min {
            
            self.errorMessage = "Entered value is too small"
            
        }
        
        return true
                
    }
    
}
