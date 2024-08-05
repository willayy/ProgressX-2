//
//  BasicSegPicker.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

struct BasicSegPicker: View {
    
    @State private var shownSegment: String = ""
    @Binding var selectedSegment: String
    let segments: [String : String]
    
    var body: some View {
        let keys: [String] = Array(segments.keys)
        Picker("Options", selection: $shownSegment) {
            ForEach(keys, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onAppear(perform: {
            shownSegment = segments.keys.first!
        })
        .onChange(of: shownSegment, initial: true) {
            selectedSegment = segments[shownSegment]!
        }
    }
}

struct BooleanSegPicker: View {
    
    @State private var shownSegment: String = ""
    @Binding var selectedSegment: Bool
    let segments: [String : Bool]
    
    var body: some View {
        let keys: [String] = Array(segments.keys)
        Picker("Options", selection: $shownSegment) {
            ForEach(keys, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onAppear(perform: {
            shownSegment = segments.keys.first!
        })
        .onChange(of: shownSegment, initial: true) {
            selectedSegment = segments[shownSegment]!
        }
    }
}


