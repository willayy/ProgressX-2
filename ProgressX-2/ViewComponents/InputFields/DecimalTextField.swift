//
//  InputDecimalNumberField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI
import Combine

/// TextField used for input of decimal numbers, using the InputField component.
struct DecimalTextField: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private var allowedChars = "1234567890.,"
    private let maxChars = 7
    let placeHolder: String
    @Binding var numberText: String
    @Binding var markAsWrong: Bool
    @Binding var errorMessage: String
    @State private var shouldShake = false
    @State var disableMaxChars = false
    let bodyWeightButton: Bool
    let allowNegatives: Bool
    
    init(
        placeHolder: String,
        numberText: Binding<String>,
        markAsWrong: Binding<Bool>,
        errorMessage: Binding<String>,
        bodyWeightButton: Bool = false,
        allowNegatives: Bool = false
    ) {
        if allowNegatives { allowedChars.append("-") }
        self.placeHolder = placeHolder
        self.allowNegatives = allowNegatives
        self.bodyWeightButton = bodyWeightButton
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
        
        // Find out of many dots there are
        let dotAmount = filtered.filter { $0 == "." }.count
        
        // If more than one dot remove last one
        if dotAmount > 1 {
            let i = filtered.lastIndex(of: ".")!
            filtered.remove(at: i)
        }
        
        return filtered
    }
    
    private func onSubmitFunction(curr: String) -> String {
        
        var mutable = curr
        
        // If the last char is a dot remove it
        if curr.last == "." {
            mutable.removeLast()
            return mutable
        }
                
        return curr
    }
    
    var body: some View {
        HStack {
            if allowNegatives {
                Button {
                    if numberText.first != "-" {
                        numberText = "-" + numberText
                    } else {
                        numberText.removeFirst()
                    }
                } label: {
                    Text("-")
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
            
            InputField(
                value: $numberText,
                markAsWrong: $markAsWrong,
                errorMessage: errorMessage,
                placeHolder: placeHolder,
                onReceiveFunction: onReceiveFunction(new:),
                onSubmitFunction: onSubmitFunction(curr:)
            )
            .keyboardType(.decimalPad)
            .onChange(
                of: numberText,
                initial: true) { _, newValue in
                    // Always convert , to .
                    numberText = newValue.replacingOccurrences(of: ",", with: ".")
                }
            
            if bodyWeightButton {
                Button {
                    let latestBodyEntry = PersistenceController.getLatestBodyEntry(viewContext)!
                    numberText = String(format: "%.2f", latestBodyEntry.bodyWeight)
                } label: {
                    Text("BW")
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    @State var inputValue: String = ""
    @State var valueIsInvalid: Bool = false
    @State var valueIsInvalidMsg: String = ""
    
    return DecimalTextField(
        placeHolder: "Testing",
        numberText: $inputValue,
        markAsWrong: $valueIsInvalid,
        errorMessage: $valueIsInvalidMsg,
        bodyWeightButton: true,
        allowNegatives: true
    )
    .environment(\.managedObjectContext, context)
    
}
