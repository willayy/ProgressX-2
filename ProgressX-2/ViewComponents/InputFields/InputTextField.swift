//
//  InputShortTextField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-20.
//

import SwiftUI
import Combine

private let nonAllowedChars = ";´`'*^¨><"

/// TextField used for short text input, composed of the base InputField component
struct InputTextField: View {
    
    let placeHolder: String
    @Binding var text: String
    @Binding var markAsWrong: Bool
    @Binding var errorMessage: String
    let maxChars: Int
    @State private var shouldShake = false

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
    
    var body: some View {
        InputField(
            value: $text,
            markAsWrong: $markAsWrong,
            errorMessage: errorMessage,
            placeHolder: placeHolder,
            onReceiveFunction: onReceiveFunction(new:),
            onSubmitFunction: onSubmitFunction(curr:)
        )
    }
}
