//
//  InputIntegerNumberField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-03.
//


import SwiftUI
import Combine

private let allowedChars = "1234567890"
private let maxChars = 5

/// TextField used for input of decimal numbers, using the InputField component.
struct InputIntegerNumberField: View {
    
    let placeHolder: String
    @Binding var numberText: String
    @Binding var markAsWrong: Bool
    let width: CGFloat
    @State private var shouldShake = false
    let errorMessage: String

    private func onReceiveFunction(new: String) -> String {
        // Filter out non allowed characters
        var filtered = new.filter { allowedChars.contains($0) }
        
        if new.count > maxChars {
            filtered.removeLast()
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
        
        InputField(value: $numberText, markAsWrong: $markAsWrong, errorMessage: errorMessage, placeHolder: placeHolder, width: width, onReceiveFunction: onReceiveFunction(new:), onSubmitFunction: onSubmitFunction(curr:))
    }
}

