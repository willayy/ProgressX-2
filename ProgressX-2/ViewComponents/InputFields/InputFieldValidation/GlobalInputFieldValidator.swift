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
    private static var fields: [(Binding<String>, Binding<Bool>, Binding<String>, Bool)] = []
    
    /// Called on InputFields appearing
    public static func addToValidationList(_ field: (Binding<String>, Binding<Bool>, Binding<String>, Bool)) -> Void  {
        
        GlobalInputFieldValidator.fields.append(field)
        
    }
    
    /// Call to staticly validate all fields ina view
    private static func staticValidate() -> Void {
        
        for field in fields {
            
            if !field.3 && field.0.wrappedValue.isEmpty {
                
                withAnimation {
                    
                    field.1.wrappedValue = false
                    
                    field.2.wrappedValue = "This is a required field!"
                    
                }
                
            }
            
        }
        
    }
    
    /// Check if all fields are valid
    public static func allFieldsValid() -> Bool {
        
        // perform static validaton
        GlobalInputFieldValidator.staticValidate()
        
        // Return true if all fiedls are valid
        return fields.allSatisfy { $0.1.wrappedValue }
        
    }
    
    /// Resets the validaton list
    public static func resetValidationList() -> Void {
        
        fields.removeAll()
        
    }
    
}

struct InputFieldForm<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .onAppear {
                GlobalInputFieldValidator.resetValidationList()
            }
    }
}
