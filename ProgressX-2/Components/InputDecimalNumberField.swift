//
//  InputDecimalNumberField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI
import Combine

private let allowedChars = "1234567890."

/// TextField used for input of decimal numbers, using the InputField component.
struct InputDecimalNumberField: View {
    
    let placeHolder: String
    @Binding var numberText: String
    @Binding var markAsWrong: Bool
    let width: CGFloat
    @State private var shouldShake = false

    private func onReceiveFunction(new: String) -> String {
        // Filter out non allowed characters
        var filtered = new.filter { allowedChars.contains($0) }
        
        // Find out of many dots there are, if more than one remove last
        let dotAmount = filtered.filter { $0 == "." }.count
        if dotAmount > 1 {
            let i = filtered.lastIndex(of: ".")!
            filtered.remove(at: i)
        }
        
        // Ensure first char isnt a dot, last char is handled in submit
        if filtered.first == "." {
            filtered.removeFirst()
        }
        
        return filtered
    }
    
    private func onSubmitFunction(curr: String) -> String {
        
        if curr.isEmpty {
            return "0.0"
        }
        
        if curr.last == "." {
            var mutable = curr
            mutable.removeLast()
            return mutable
        }
        
        return curr
    }
    
    var body: some View {
        
        InputField(value: $numberText, markAsWrong: $markAsWrong, placeHolder: placeHolder, width: width, onReceiveFunction: onReceiveFunction(new:), onSubmitFunction: onSubmitFunction(curr:))
    }
}
