//
//  InputDecimalNumberField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI
import Combine

/// TextField used for input of decimal numbers, using the InputField component.
struct InputDecimalNumberField: View {
    
    private var allowedChars = "1234567890.,"
    private let maxChars = 6
    let placeHolder: String
    let allowNegatives: Bool
    let width: CGFloat
    @Binding var numberText: String
    @Binding var markAsWrong: Bool
    @State private var shouldShake = false
    @State var disableMaxChars = false
    @Binding var errorMessage: String
    
    #warning("TODO: Fix not being able to input - sign")
    
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
        var filtered = new.filter {
            allowedChars.contains($0)
        }
        
        // Ensure first char isnt a dot, last char is handled in submit
        if filtered.first == "." {
            filtered.removeFirst()
        }
        
        // Ensure that number isnt longer than max chars
        if new.count > maxChars && !disableMaxChars {
            filtered.removeLast()
        }
        
        // Ensure minus is only at the beginning
        if new.contains("-") && new.first != "-" {
            filtered.removeAll(where: { $0 == "-" })
        }
        
        // Find out of many dots there are, if more than one remove last
        let dotAmount = filtered.filter { $0 == "." }.count
        if dotAmount > 1 {
            let i = filtered.lastIndex(of: ".")!
            filtered.remove(at: i)
        }
        
        return filtered
    }
    
    private func onSubmitFunction(curr: String) -> String {
        
        var mutable = curr
        
        if curr.isEmpty {
            return "0.0"
        }
        
        if curr.last == "." {
            mutable += "0"
            disableMaxChars = true
            return mutable
        }
                
        return curr
    }
    
    var body: some View {
        
        InputField(value: $numberText, markAsWrong: $markAsWrong, errorMessage: errorMessage, placeHolder: placeHolder, width: width, onReceiveFunction: onReceiveFunction(new:), onSubmitFunction: onSubmitFunction(curr:))
            .keyboardType(.decimalPad)
            .onChange(
                of: numberText,
                initial: true) { _, newValue in
                    // Always convert , to .
                    numberText = newValue.replacingOccurrences(of: ",", with: ".")
                }
    }
}
