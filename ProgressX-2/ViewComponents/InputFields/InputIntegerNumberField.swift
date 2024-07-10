//
//  InputIntegerNumberField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-03.
//


import SwiftUI
import Combine

#warning("TODO: Fix not being able to input - sign")

/// TextField used for input of decimal numbers, using the InputField component.
struct InputIntegerNumberField: View {
    
    private var allowedChars = "1234567890"
    private let maxChars = 5
    let placeHolder: String
    let allowNegatives: Bool
    @Binding var numberText: String
    @Binding var markAsWrong: Bool
    let width: CGFloat
    @State private var shouldShake = false
    @Binding var errorMessage: String
    
    init(
        placeHolder: String,
        allowNegatives: Bool,
        numberText: Binding<String>,
        markAsWrong: Binding<Bool>,
        width: CGFloat,
        errorMessage: Binding<String>
    ) {
        if allowNegatives { allowedChars.append("-") }
        self.placeHolder = placeHolder
        self.allowNegatives = allowNegatives
        self.width = width
        self._errorMessage = errorMessage
        self._numberText = numberText
        self._markAsWrong = markAsWrong
    }

    private func onReceiveFunction(new: String) -> String {
        
        // Filter out non allowed characters
        var filtered = new.filter { allowedChars.contains($0) }
        
        if new.count > maxChars {
            filtered.removeLast()
        }
        
        // Ensure minus is only at the beginning
        if new.contains("-") && new.first != "-" {
            filtered.removeAll(where: { $0 == "-" })
        }
        
        return filtered
    }
    
    private func onSubmitFunction(curr: String) -> String {
        
        if curr.isEmpty {
            return "0"
        }
        
        return curr
    }
    
    var body: some View {
        
        InputField(
            value: $numberText,
            markAsWrong: $markAsWrong,
            errorMessage: errorMessage,
            placeHolder: placeHolder,
            width: width,
            onReceiveFunction: onReceiveFunction(new:),
            onSubmitFunction: onSubmitFunction(curr:)
        )
        .keyboardType(.numberPad)
    }
}

