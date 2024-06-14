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
    
    override public func valideField(inputVar: String, errorMessage: Binding<String>, fieldInvalid: Binding<Bool>) -> Bool {
        
            if !emptyAllowed && inputVar.isEmpty {
                withAnimation(.easeIn) {
                    errorMessage.wrappedValue = "Input cant be empty!"
                    fieldInvalid.wrappedValue = true
                }
                return false
            }
        
            if Double(inputVar) != nil {} else {
                withAnimation(.easeIn) {
                    errorMessage.wrappedValue = "Input is not a valid number!"
                    fieldInvalid.wrappedValue = true
                }
                return false
            }
            
            if Double(inputVar)! < minInputNumber {
                withAnimation(.easeIn) {
                    errorMessage.wrappedValue = "Input number is too small!"
                    fieldInvalid.wrappedValue = true
                }
                return false
            }
            
            if Double(inputVar)! > maxInputNumber {
                withAnimation(.easeIn) {
                    errorMessage.wrappedValue = "Input number is too big!"
                    fieldInvalid.wrappedValue = true
                }
                return false
            }
        
        return true
        
    }
    
}
