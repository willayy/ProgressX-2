//
//  TextIF.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-07.
//

import Foundation

class TextIF: InputFieldVariant {
    
    static private var allowedChars: Set<Character> = [
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "'", "\\", "`",
        "~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_",
        "=", "+", "[", "]", "{", "}", ";", ":", ",", ".", "/", "<", ">", "?"
    ]

    
    public init(allowEmpty: Bool) {
        super.init(
            allowedChars: TextIF.allowedChars,
            keyBoardType: .default,
            minScaleFactor: 0.75,
            maxChars: 100,
            allowEmpty: allowEmpty
        )
    }
    
    override internal func filterInput(_ new: String) -> String {
        
        // Filter away non-allowed characters.
        var filtered = new.filter { allowedChars.contains($0) }
        
        // Ensure that number isnt longer than max chars
        if filtered.count > maxChars {
            filtered.removeLast()
        }
        
        return filtered
        
    }
    
    override internal func dynamicValidation(_ filtered: String) -> Bool {
        
        // Reset error message
        self.errorMessage = ""
        
        // if the field is empty let it pass the dynamic validation
        return true
        
    }
}
