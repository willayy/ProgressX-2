//
//  InputShortTextField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-20.
//

import SwiftUI
import Combine

private let nonAllowedChars = ".,;-"
private let maxChars = 25

/// TextField used for short text input, composed of the base InputField component
struct InputShortTextField: View {
    
    let placeHolder: String
    @Binding var text: String
    @Binding var markAsWrong: Bool
    let width: CGFloat
    @State private var shouldShake = false

    private func onReceiveFunction(new: String) -> String {
        var filtered = new.filter { !nonAllowedChars.contains($0) }
        if filtered.count > 25 {
            filtered.removeLast()
        }
        return filtered
    }
    
    private func onSubmitFunction(curr: String) -> String {
        return ""
    }
    
    var body: some View {
        InputField(value: $text, markAsWrong: $markAsWrong, placeHolder: placeHolder, width: width, onReceiveFunction: onReceiveFunction(new:), onSubmitFunction: onSubmitFunction(curr:))
    }
}
