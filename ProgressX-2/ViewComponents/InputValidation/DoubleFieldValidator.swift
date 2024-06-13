//
//  DoubleFieldValidator.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-13.
//

import Foundation
import SwiftUI

class DoubleFieldValidator: InputFieldValidator {
    
    private let minInputNumber: Double
    private let maxInputNumber: Double
    
    init(emptyAllowed: Bool = false, minInputNumber: Double = 0, maxInputNumber: Double = 1000) {
        self.minInputNumber = minInputNumber
        self.maxInputNumber = maxInputNumber
        super.init(emptyAllowed: emptyAllowed)
    }
    
    override public func valideField(inputVar: String, errorMessage: Binding<String>, fieldValid: Binding<Bool>) -> Bool {
        var caughtError: Bool = true
        errorMessage.wrappedValue = ""
        
        withAnimation {
            if let intValue = Double(inputVar) {} else {
                caughtError = false
                errorMessage.wrappedValue = "Input is not a valid number!"
            }
            
            if Double(inputVar)! < minInputNumber {
                caughtError = false
                errorMessage.wrappedValue = "Input number is too small!"
            }
            
            else if Double(inputVar)! > minInputNumber {
                caughtError = false
                errorMessage.wrappedValue = "Input number is too big!"
            }
            
            else if !emptyAllowed && inputVar.isEmpty {
                caughtError = false
                errorMessage.wrappedValue = "Input cant be empty!"
            }
        
            fieldValid.wrappedValue = !caughtError
        }
        
        return caughtError
        
    }
    
}
