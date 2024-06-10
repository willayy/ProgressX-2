//
//  BasicSegPicker.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

struct BasicSegPicker: View {
    
    @Binding var selectedSegment: String
    let segments: [String]
    let frameWidth: CGFloat
    let horizontalPadding: CGFloat
    
    var body: some View {
        Picker("Options", selection: $selectedSegment) {
            ForEach(segments, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(width: frameWidth)
        .padding(.horizontal, horizontalPadding)
    }
}
