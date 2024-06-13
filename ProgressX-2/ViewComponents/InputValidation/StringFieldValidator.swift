//
//  StringFieldValidator.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-13.
//

import Foundation
import SwiftUI

class StringFieldValidator: InputFieldValidator {
    
    private let minInputCharCount: Int 
    private let maxInputCharCount: Int
    
    init(emptyAllowed: Bool = false, minInputCharCount: Int = 0, maxInputCharCount: Int = 1000) {
        self.minInputCharCount = minInputCharCount
        self.maxInputCharCount = maxInputCharCount
        super.init(emptyAllowed: emptyAllowed)
    }
    
    override public func valideField(inputVar: String, errorMessage: Binding<String>, fieldValid: Binding<Bool>) -> Bool {
        var caughtError: Bool = true
        errorMessage.wrappedValue = ""
        
        withAnimation {
            if inputVar.count < minInputCharCount {
                caughtError = false
                errorMessage.wrappedValue = "Input text too short!"
            }
            
            else if inputVar.count > maxInputCharCount {
                caughtError = false
                errorMessage.wrappedValue = "Input text too long!"
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
