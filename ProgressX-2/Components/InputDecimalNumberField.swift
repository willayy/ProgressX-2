//
//  InputDecimalNumberField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI
import Combine
struct InputDecimalNumberField: View {
    
    let placeHolder: String
    @Binding var numberText: String
    let width: CGFloat

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        VStack {
            TextField(placeHolder, text: $numberText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width * width)
                .multilineTextAlignment(.center)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(foreGroundColorGray)
                        .padding(.all, -3)
                )
                .onReceive(Just(numberText)) { newText in
                    // Handle text change
                    print("Text changed to: \(newText)")
                }
                .onSubmit {
                    // Handle when return key is pressed
                    print("Submitted")
                }
        }
    }
}

