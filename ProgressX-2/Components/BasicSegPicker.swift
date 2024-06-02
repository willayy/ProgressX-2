//
//  BasicSegPicker.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

struct BasicSegPicker: View {
    
    @Binding var selectedSegment: Int
    let segments: [String]
    
    var body: some View {
        Picker(selection: $selectedSegment, label: Text("")) {
            ForEach(0..<segments.count) { index in
                Text(segments[index])
                    .tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 230)
            .padding(-3)
    }
}
