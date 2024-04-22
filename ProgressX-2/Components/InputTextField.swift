//
//  File.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-20.
//

import SwiftUI
import Combine
struct InputTextField: View {
    
    let placeHolder: String
    @Binding var text: String
    let width: CGFloat
    private let foreGroundColor: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    
    var body: some View {
        TextField(placeHolder, text: $text)
            .frame(width: UIScreen.main.bounds.width * width)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(foreGroundColor)
                    .padding(.all, -3)
            )
            .onReceive(Just(text)) { newText in
                // Handle text change
                print("Text changed to: \(newText)")
            }
            .onSubmit {
                // Handle when return key is pressed
                print("Submitted")
            }
    }
}
