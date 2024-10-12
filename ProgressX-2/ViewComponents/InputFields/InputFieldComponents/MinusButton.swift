//
//  MinusButton.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-07.
//

import SwiftUI

struct MinusButton: View {
    
    @Binding public var text: String
    
    var body: some View {
            
            Button {
                
                if text.first != "-" {
                    
                    text = "-" + text
                    
                } else {
                    
                    text.removeFirst()
                    
                }
                
            } label: {
                
                Text("-")
                
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .foregroundColor(Color("buttonTextColor"))
        
    }
}
