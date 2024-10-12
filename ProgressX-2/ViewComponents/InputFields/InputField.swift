//
//  InputField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-03.
//

import SwiftUI
import Combine

/// An input restricting, self validating view component based on the TextField.
struct InputField: View {
    
    // Default access id
    public let accessId: String = ""
    
    public let placeHolder: String
    
    @Binding public var text: String
    
    @State private var valid: Bool = true
    
    @FocusState private var isTextFieldFocused
    
    @State private var shouldShake: Bool = false
    
    @StateObject public var variant: InputFieldVariant
    
    var body: some View {
        
        HStack {
            
            // Include minusbutton if included in variant.
            if includeMinusButton { MinusButton(text: $text) }
            
            TextField(placeHolder, text: $text)
            // Access id for the UI-tests
            .accessibilityIdentifier(accessId)
            .frame(maxWidth: .infinity)
            // Textfield visual style.
            .textFieldStyle(RoundedBorderTextFieldStyle())
            // The minimum scale factor of the textfield text.
            .minimumScaleFactor(0.75)
            // The keyboard type
            .keyboardType(.numbersAndPunctuation)
            // Set the variable for the focused state of this textfield.
            .focused($isTextFieldFocused)
            // When textfield is tapped unfocus it and hide the keyboard.
            .onTapGesture { dismissTextField() }
            // Making the border red if valid is false.
            .modifier(WrongTextFieldEffect(isWrong: !self.valid))
            // The actual moving/translation of the view element.
            .modifier(ShakeEffect(shakes: self.shouldShake ? 2 : 0))
            // The animation, or the smoothness of the moving.
            .animation(Animation.default.repeatCount(1).speed(2), value: self.shouldShake)
            // On change custom behaviour from varaint can be applied:
            .onChange(of: text, initial: true) { _,new  in
                // Filter new input
                self.filterInput(new)
                // Perform dynamic validation
                self.dynamicValidation(self.text)
            }
            .onAppear(perform: {
                // Add the field to the Global validator
                let fieldValues = ($text, $valid, $variant.errorMessage, variant.allowEmpty)
                GlobalInputFieldValidator.addToValidationList(fieldValues)
            })
            
            // Include BwButton if included in variant.
            if includeBwButton { BwButton(text: $text) }
            
        }
        
        // If the textfield contians valid input...
        if !self.valid {
                
            // Show error message provided by variant!
            ErrorMessage(message: $variant.errorMessage)
            
        }
        
    }
    
}

extension InputField {
    
    /// Checks if the InputFieldVariant is numeric
    private var variantIsNumeric: Bool {
        
        if variant is NumericInputFieldVariant {
            
            return true
            
        } else {
            
            return false
            
        }
        
    }
    
    /// Returns true if variant is numeric and bwButton is true.
    private var includeBwButton: Bool {
        
        if variantIsNumeric {
            
            return (variant as! NumericInputFieldVariant).bwButton
            
        } else {
            
            return false
            
        }
        
    }
    
    /// Returns true if variant is numeric and allowNegatives is true.
    private var includeMinusButton: Bool {
        
        if variantIsNumeric {
            
            return (variant as! NumericInputFieldVariant).allowNegatives
            
        } else {
            
            return false
            
        }
        
    }
    
    /// Calls the variant objecst filter method and filters the new input
    private func filterInput(_ input: String) {
        
        let filtered = variant.filterInput(input)
        
        if filtered != input {
            
            self.text = filtered
            
            self.shouldShake.toggle()
            
        }
        
    }
    
    /// Calls the variant objects validation method and validates the input, field becomes red if its not valid.
    private func dynamicValidation(_ input: String) {
        
        withAnimation {
            
            self.valid = variant.dynamicValidation(input)
            
        }
        
    }
    
    /// Dismisses the TextField in two steps.
    private func dismissTextField() {
        
        self.hideKeyboard()
        
        self.unFocusTextField()
        
    }
    
    /// Unfocuses TextField by setting FocusState to false.
    private func unFocusTextField() {
        
        self.isTextFieldFocused = false
        
    }
    
    /// Hides keyboard in a kind of janky way, this might cause bugs...
    private func hideKeyboard() {
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
    }
    
}

private struct InputFieldTestView: View {
    
    let context = PersistenceController.previewViewContext
    
    @State var valid: Bool = true
    
    @State var text: String = ""
    
    var body: some View {
        
        VStack {
            
            InputField(
                placeHolder: "Write something here",
                text: $text,
                variant: DecimalIF(
                    min: 0,
                    max: 10000,
                    bwButton: true,
                    allowNeg: true,
                    optional: false
                )
            )
            .padding(.horizontal, 20)
        
        }
        .environment(\.managedObjectContext, context)
        
    }
}

#Preview {
    
    return InputFieldTestView()
    
}
