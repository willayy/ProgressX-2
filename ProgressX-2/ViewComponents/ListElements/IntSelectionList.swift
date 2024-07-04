//
//  IntSelectionList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-03.
//

import SwiftUI

struct IntSelectionList: View {

    @Binding var selected: Int64
    let selections: [Int64]
    
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
        .padding(.horizontal, 100)
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
