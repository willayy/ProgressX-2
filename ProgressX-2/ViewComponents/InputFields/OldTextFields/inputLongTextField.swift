//
//  inputLongTextField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import SwiftUI
import Combine

private let nonAllowedChars = ";´`'*^¨><"

struct inputLongTextField: View {
    
    let placeHolder: String
    @Binding var text: String
    @Binding var markAsWrong: Bool
    @Binding var errorMessage: String
    let maxChars: Int
    @State private var shouldShake = false
    @FocusState private var isTextFieldFocused
    
    var body: some View {
        
        ZStack {
            
            if text.isEmpty {
                Text(placeHolder)
                    .fontWeight(.light)
                    .foregroundStyle(.gray.opacity(0.75))
                    .zIndex(1)
            }
            
            TextEditor(text: $text)
                .onReceive(Just(text)) { newValue in
                    let filtered = onReceiveFunction(new: newValue)
                    if filtered != newValue {
                        self.text = filtered
                        self.shouldShake.toggle()
                    }
                }
                .focused($isTextFieldFocused)
                .onTapGesture {
                    self.hideKeyboard()
                    isTextFieldFocused = false
                }
                .onSubmit {
                    // Handle when return key is pressed and field is empty
                    self.text = onSubmitFunction(curr: text)
                }
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.20), lineWidth: 1)
                )
                .font(.subheadline)
                .foregroundColor(.primary)
                // Making the border red if markAsWrong is true
                .modifier(WrongTextFieldEffect(isWrong: self.markAsWrong))
                // The actual moving/translation of the view element
                .modifier(ShakeEffect(shakes: self.shouldShake ? 2 : 0))
                // The animation, or the smoothness of the moving
                .animation(Animation.default.repeatCount(1).speed(2), value: self.shouldShake)
        }
        
        if markAsWrong {
            Text(errorMessage)
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(.red)
        }
        
    }
    
    private func onReceiveFunction(new: String) -> String {
        var filtered = new.filter { !nonAllowedChars.contains($0) }
        if filtered.count > maxChars {
            filtered.removeLast()
        }
        return filtered
    }
    
    private func onSubmitFunction(curr: String) -> String {
        return curr
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

#Preview {
    @State var text: String = ""
    @State var markAsWrong: Bool = false
    @State var errorMessage: String = "Error"
    
    return inputLongTextField(
        placeHolder: "Write something",
        text: $text,
        markAsWrong: $markAsWrong,
        errorMessage: $errorMessage,
        maxChars: 400
    )
    .padding(50)
}
