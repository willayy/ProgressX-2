//
//  LargeTextInputField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-08.
//

import SwiftUI

struct LargeTextInputField: View {
    
    public let placeHolder: String
    
    @Binding public var text: String
    
    @Binding public var valid: Bool
    
    @FocusState private var isTextFieldFocused
    
    @State private var shouldShake: Bool = false
    
    @StateObject public var variant: InputFieldVariant
    
    var body: some View {
        
        ZStack {
            
            // Placeholder for TextEditor
            if text.isEmpty {
                Text(placeHolder)
                    .fontWeight(.light)
                    .foregroundStyle(.gray.opacity(0.75))
                    .zIndex(1)
            }
            
            TextEditor(text: $text)
            .frame(maxWidth: .infinity)
            // Texteditor visual style.
            .background(Color.white)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.20), lineWidth: 1)
            )
            .font(.subheadline)
            .foregroundColor(.primary)
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
                // if variant doesnt allow empty fields
                if !self.variant.allowEmpty {
                    // Add the field to the Global validator
                    let fieldValues = ($text, $valid, $variant.errorMessage)
                    GlobalInputFieldValidator.addToValidationList(fieldValues)
                }
            })
            
        }
        
        // If the textfield contians valid input...
        if !self.valid {
                
            // Show error message provided by variant!
            ErrorMessage(message: $variant.errorMessage)
            
        }
        
    }
    
}

extension LargeTextInputField {
    
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

private struct LargeTextInputFieldTestView: View {
    
    @State var valid: Bool = true
    
    @State var text: String = ""
    
    var body: some View {
        
        VStack {
            
            LargeTextInputField(
                placeHolder: "Big text area",
                text: $text,
                valid: $valid,
                variant: TextIF(
                    allowEmpty: false
                )
            )
            .padding(.horizontal, 50)
            .padding(.vertical, 300)
            
        }
    }
}

#Preview {
    
    return LargeTextInputFieldTestView()
    
}
