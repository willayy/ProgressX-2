//
//  InputField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-27.
//
import SwiftUI
import Combine

struct InputField: View {
    
    @State private var shouldShake = false
    @Binding var value: String
    @Binding var markAsWrong: Bool
    let errorMessage: String
    let placeHolder: String
    let onReceiveFunction: (String) -> String
    let onSubmitFunction: (String) -> String
    @FocusState private var isTextFieldFocused

    var body: some View {
        
        VStack {
            
            TextField(placeHolder, text: $value)
            
                // The minimum scale factor of the text in the texfield
                .minimumScaleFactor(0.75)
                
                // The visual style of the texfield
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
                // On revieving new text
                .onReceive(Just(value)) { newValue in
                    
                    let filtered = onReceiveFunction(newValue)
                    
                    if filtered != newValue {
                        
                        self.value = filtered
                        
                        self.shouldShake.toggle()
                        
                    }
                    
                }
                
                // Set the variable for the focused state of this textfield
                .focused($isTextFieldFocused)
                
                // Fires when the textfield is tapped
                .onTapGesture {
                    
                    self.hideKeyboard()
                    
                    isTextFieldFocused = false
                    
                }
                
                // On textfield being submitted
                .onSubmit {
                    
                    // Handle when return key is pressed and field is empty
                    self.value = onSubmitFunction(value)
                    
                }
            
                // Making the border red if markAsWrong is true
                .modifier(WrongTextFieldEffect(isWrong: self.markAsWrong))
            
                // The actual moving/translation of the view element
                .modifier(ShakeEffect(shakes: self.shouldShake ? 2 : 0))
            
                // The animation, or the smoothness of the moving
                .animation(Animation.default.repeatCount(1).speed(2), value: self.shouldShake)
                
            if markAsWrong {
                Text(errorMessage)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.red)
            }
            
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
