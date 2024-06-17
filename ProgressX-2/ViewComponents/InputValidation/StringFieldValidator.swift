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
    
    override public func valideField(inputVar: String, errorMessage: Binding<String>, fieldInvalid: Binding<Bool>) -> Int {
        
        if inputVar.count < minInputCharCount {
            withAnimation(.easeIn) {
                errorMessage.wrappedValue = "Input text too short!"
                fieldInvalid.wrappedValue = true
            }
            return 1
        }
        
        if inputVar.count > maxInputCharCount {
            withAnimation(.easeIn) {
                errorMessage.wrappedValue = "Input text is too big!"
                fieldInvalid.wrappedValue = true
            }
            return 1
        }
        
        if !emptyAllowed && inputVar.isEmpty {
            withAnimation(.easeIn) {
                errorMessage.wrappedValue = "Input cant be empty!"
                fieldInvalid.wrappedValue = true
            }
            return 1
        }
        
        return 0
        
    }
    
}
