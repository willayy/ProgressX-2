//
//  CircleProgressView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-24.
//

import Foundation
import SwiftUI

struct CircleProgressView: View {
    
    @Binding var progress: Float

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8.0)
                .opacity(0.3)
                .foregroundColor(.blue)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.red)
            // Ensures the animation starts from 12 o'clock
                .rotationEffect(Angle(degrees: 270))
        }
        // The progress animation will animate over 1 second which
        // allows for a continuous smooth update of the ProgressView
        .animation(.linear(duration: 1.0), value: progress)
    }
}
