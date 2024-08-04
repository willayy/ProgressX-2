//
//  BasicSegPicker.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

struct BasicSegPicker: View {
    
    @Binding var selectedSegment: String
    let segments: [String : String]
    
    var body: some View {
        let keys: [String] = Array(segments.keys)
        Picker("Options", selection: $selectedSegment) {
            ForEach(keys, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct BooleanSegPicker: View {
    
    @Binding var selectedSegment: String
    let segments: [String : Bool]
    
    var body: some View {
        let keys: [String] = Array(segments.keys)
        Picker("Options", selection: $selectedSegment) {
            ForEach(keys, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}


