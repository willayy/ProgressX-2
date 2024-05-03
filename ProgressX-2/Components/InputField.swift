//
//  InputField.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-27.
//
import SwiftUI
import Combine

struct InputField: View {
    
    @State private var shouldShake = false
    @Binding var value: String
    let markAsWrong: Bool
    
    let placeHolder: String
    let width: CGFloat
    let onReceiveFunction: (String) -> String
    let onSubmitFunction: (String) -> String

    var body: some View {
        VStack {
            TextField(placeHolder, text: $value)
                .frame(width: UIScreen.main.bounds.width * width)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onReceive(Just(value)) { newValue in
                    let filtered = onReceiveFunction(newValue)
                    if filtered != newValue {
                        self.value = filtered
                        self.shouldShake.toggle()
                    }
                }
                .onSubmit {
                    // Handle when return key is pressed and field is empty
                    self.value = onSubmitFunction(value)
                }
                // Making the border red if markAsWrong is true
                .modifier(WrongTextFieldEffect(isWrong: self.markAsWrong))
                // The actual moving/translation of the view element
                .modifier(ShakeEffect(shakes: self.shouldShake ? 2 : 0))
                // The animation, or the smoothness of the moving
                .animation(Animation.default.repeatCount(1).speed(2), value: self.shouldShake)
        }
    }
}

struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -10 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }

    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

struct WrongTextFieldEffect: ViewModifier {
    var isWrong: Bool

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isWrong ? Color.red : Color.clear, lineWidth: 1)
        )
    }
}
