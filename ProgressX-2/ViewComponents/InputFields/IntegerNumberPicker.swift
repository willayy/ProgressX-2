//
//  IntegerNumberPicker.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI

struct IntegerNumberPicker: View {
    
    @Binding var selectedNumber: Int64
    @State private var lowerBound: Int64 = 1
    @State private var upperBound: Int64 = 100
    private let maxUpperBound: Int64 = 100000
    
    var body: some View {
        
        #warning("TODO: Implement this")
        
        let range = lowerBound...upperBound
        
        GroupBox {
            HStack {
                Button {
                    if selectedNumber > lowerBound {
                        selectedNumber -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 15, height: 15)
                }
                .buttonStyle(BorderedProminentButtonStyle())
                
                Picker("Select a number", selection: $selectedNumber) {
                    ForEach(range, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 40)
                
                Button {
                    if selectedNumber < upperBound {
                        selectedNumber += 1
                    }
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 15, height: 15)
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
            .padding(.vertical, -10)
        }
        .padding(.horizontal, 55)
        .onChange(of: selectedNumber, initial: false) {
            if selectedNumber >= upperBound && upperBound < maxUpperBound {
                upperBound += 100
            }
        }
    }
}

#Preview {
    
    @State var selectedNumber: Int64 = 1
    
    return IntegerNumberPicker(selectedNumber: $selectedNumber)
}
