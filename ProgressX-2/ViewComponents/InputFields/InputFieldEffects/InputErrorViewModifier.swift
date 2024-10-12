//
//  InputErrorViewModifier.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import SwiftUI

public struct WrongTextFieldEffect: ViewModifier {
    
   public var isWrong: Bool

    public func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isWrong ? Color.red : Color.clear, lineWidth: 1)
        )
    }
}
