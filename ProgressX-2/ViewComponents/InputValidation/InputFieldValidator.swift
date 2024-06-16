//
//  InputFieldValidators.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-13.
//

import Foundation
import SwiftUI

// Contains static methods to validate input fields on submitting a form.
class InputFieldValidator {
    
    let emptyAllowed: Bool
    
    init(emptyAllowed: Bool = false) {
        self.emptyAllowed = emptyAllowed
    }
    
    // Replace with protocol in the future
    /// Returns 1 if invalid 0 otherwise
    /// - Parameters:
    ///   - inputVar: The input value of the field
    ///   - errorMessage: The error message state
    ///   - fieldInvalid: The field invalid state
    /// - Returns: 1 or 0 (Int)
    public func valideField(inputVar: String, errorMessage: Binding<String>, fieldInvalid: Binding<Bool>) -> Int {
        fatalError("This must be overrided in InputFieldValidator subclasses")
    }
    
}
