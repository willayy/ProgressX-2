//
//  IntSelectionList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-03.
//

import SwiftUI

struct IntSelectionList: View {

    @Binding private var selected: Int64
    
    private let selections: [Int64]
    
    init(selected: Binding<Int64>, selections: [Int64]) {
        
        self._selected = selected
        
        self.selections = selections.sorted()
        
    }
    
    var body: some View {
        
        GroupBox {
            
            DisclosureGroup(String(selected)) {
                
                ForEach(selections, id: \.self) { int in
                    
                    Button {
                        
                        selected = int
                        
                    } label: {
                        
                        Text(String(int))
                        
                    }
                    .padding(2)
                    
                }
            }
        }
    }
}

#Preview {
    
    @State var selectedType: Int64 = 1
    let selections: [Int64] = [1, 2, 3]
    
    return IntSelectionList(
        selected: $selectedType,
        selections: selections
    )
}
