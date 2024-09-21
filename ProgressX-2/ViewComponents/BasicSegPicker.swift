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
    
    let segments: KeyValueList<String, String>
    
    var body: some View {
        
        let keys: [String] = segments.keys
        
        Picker("Options", selection: $shownSegment) {
            
            ForEach(keys, id: \.self) { option in
                
                Text(option).tag(option)
                
            }
            
        }
        .pickerStyle(SegmentedPickerStyle())
        .onAppear(perform: {
            
            shownSegment = segments.first { $0.1 == selectedSegment }!.0
            
        })
        .onChange(of: shownSegment, initial: true) {
            
            
            selectedSegment = segments.get(key: shownSegment)!
            
            
        }
    }
}

struct BooleanSegPicker: View {
    
    @State private var shownSegment: String = ""
    
    @Binding var selectedSegment: Bool
    
    let segments: KeyValueList<String, Bool>
    
    var body: some View {
        
        let keys: [String] = segments.keys
        
        Picker("Options", selection: $shownSegment) {
            
            ForEach(keys, id: \.self) { option in
                
                Text(option).tag(option)
                
            }
            
        }
        .pickerStyle(SegmentedPickerStyle())
        .onAppear(perform: {
            
            shownSegment = segments.first { $0.1 == selectedSegment }!.0
            
        })
        .onChange(of: shownSegment, initial: true) {
            
            selectedSegment = segments.get(key: shownSegment)!
            
        }
    }
}


