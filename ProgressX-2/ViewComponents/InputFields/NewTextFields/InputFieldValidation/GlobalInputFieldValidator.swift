//
//  GlobalInputFieldValidator.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-08.
//

import Foundation
import SwiftUI

/// A global validator for InputFields that performs static validation on all fields in a view.
class GlobalInputFieldValidator {
    
    // All fields checked by the validator
    private static var fields: [(Binding<String>, Binding<Bool>, Binding<String>)] = []
    
    /// Called on InputFields appearing
    public static func addToValidationList(_ field: (Binding<String>, Binding<Bool>, Binding<String>)) -> Void  {
        
        GlobalInputFieldValidator.fields.append(field)
        
    }
    
    /// Call to staticly validate all fields ina view
    public static func staticValidate() -> Void {
        
        for field in fields {
            
            if field.0.wrappedValue.isEmpty {
                
                withAnimation {
                    
                    field.1.wrappedValue = false
                    
                    field.2.wrappedValue = "This is a required field!"
                    
                }
                
            }
            
        }
        
    }
    
    /// Resets the validaton list
    public static func resetValidationList() -> Void {
        
        fields.removeAll()
        
    }
    
}

extension View {
    
    /// A view which calls this modifier will resest the validationList every time it loads
    func inputFieldForm() -> some View {
        
        self.onAppear(perform: {
            
            GlobalInputFieldValidator.resetValidationList()
            
        })
        
    }
    
}
