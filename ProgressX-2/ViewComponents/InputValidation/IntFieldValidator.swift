//
//  IntFieldValidator.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-13.
//

import Foundation
import SwiftUI

class IntFieldValidator: InputFieldValidator {
    
    private let minInputNumber: Int
    private let maxInputNumber: Int
    
    init(emptyAllowed: Bool = false, minInputNumber: Int = 0, maxInputNumber: Int = 1000) {
        super.init(emptyAllowed: emptyAllowed)
        self.minInputNumber = minInputNumber
        self.maxInputNumber = maxInputNumber
    }
    
    override public func valideField(inputVar: String, errorMessage: Binding<String>, fieldValid: Binding<Bool>) -> Bool {
        var caughtError: Bool = true
        errorMessage.wrappedValue = ""
        
        withAnimation {
            if let intValue = Int(inputVar) {} else {
                caughtError = false
                errorMessage.wrappedValue = "Input is not a valid number!"
            }
            
            if Int(inputVar)! < minInputNumber {
                caughtError = false
                errorMessage.wrappedValue = "Input number is too small!"
            }
            
            else if Int(inputVar)! > maxInputNumber {
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
