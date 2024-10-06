//
//  InputField2.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-03.
//

import SwiftUI
import Combine

/// An input restricting, self validating view component based on the TextField.
struct InputField2: View {
    
    public let placeHolder: String
    
    @Binding public var text: String
    
    @Binding public var valid: Bool
    
    @StateObject public var variant: InputFieldVariant
    
    @FocusState private var isTextFieldFocused
    
    @State private var shouldShake: Bool = false
    
    var body: some View {
        
        TextField(placeHolder, text: $text)
        
            frame(maxWidth: .infinity, idealHeight: 15)
        
            // Textfield visual style.
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // The minimum scale factor of the textfield text.
            .minimumScaleFactor(variant.minScaleFactor)
        
            .keyboardType(variant.keyBoardType)
        
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
            
            // On recieve new text filter the input and validate it.
            .onReceive(Just(text), perform: { input in filterInput(input); validateInput(input) })
        
            // On change custom behaviour from varaint can be applied:
            .onChange(of: text, initial: true) { old,new  in self.onChange(new) }
        
        // If the textfield contians valid input...
        if !self.valid {
            
            // Show error message provided by variant!
            ErrorMessage(message: $variant.errorMessage)
            
        }
        
    }
    
}

/// Inpiut field Methods
extension InputField2 {
    
    /// Calls the variant objects validation method and validates the input.
    private func onChange(_ input: String) {
        
        self.text = variant.onChange(input)
        
    }
    
    /// Calls the variant objects validation method and validates the input, field becomes red if its not valid.
    private func validateInput(_ input: String) {
        
        self.valid = self.variant.isValid(input)
        
    }
    
    /// Calls the variant objects filter method and filters the input, shakes if non allowed character is detected.
    private func filterInput(_ input: String) {
        
        let filtered = self.variant.filterInput(input)
        
        if filtered != input {
            
            self.text = filtered
            
            self.shouldShake.toggle()
            
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

#Preview {
    
    @State var valid: Bool = true
    
    @State var text: String = ""
    
    @State var buttonForeGroundStyle = Color.red
    
    let view = VStack {
        
        InputField2(
            placeHolder: "Hello world im a textfield",
            text: $text,
            valid: $valid,
            variant: DecimalIF(min: 0, max: 10000, optional: false)
        )
        
        Button {
            // Does nothing
        } label: {
            Text("Press me!")
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .disabled(!valid)
        
    }
    
    return view
                
}
