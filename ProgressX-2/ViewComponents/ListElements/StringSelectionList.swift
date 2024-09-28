//
//  SetLQTypesSelectionList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-03.
//

import SwiftUI

struct StringSelectionList: View {
    
    @Binding var selected: String
    let selections: [String]
    
    var body: some View {
        
        GroupBox {
            
            DisclosureGroup(selected) {
                
                ForEach(selections, id: \.self) { type in
                    
                    Button {
                        
                        selected = type
                        
                    } label: {
                        
                        Text(type)
                        
                    }
                    .padding(2)
                }
            }
        }
    }
}

#Preview {
    
    @State var selectedType = "value 1"
    let selections: [String] = ["value 1", "value 2", "value 3"]
    
    return StringSelectionList(
        selected: $selectedType,
        selections: selections
    )
}
