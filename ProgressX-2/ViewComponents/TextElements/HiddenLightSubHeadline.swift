//
//  HiddenLightSubHeadline.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-25.
//

import SwiftUI

struct HiddenLightSubHeadline: View {
    
    let title: String
    let text: String
    @State private var expanded: Bool = false
    @State private var systemName: String = "arrowtriangle.right"
    
    var body: some View {
        VStack {
            Button {
                withAnimation(.linear) {
                    expanded.toggle()
                    if expanded {
                        systemName = "arrowtriangle.down"
                    } else {
                        systemName = "arrowtriangle.right"
                    }
                }
            } label: {
                Text(title)
                    .foregroundColor(Color("lighterTextColor"))
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Image(systemName: systemName)
                    .foregroundColor(Color("lighterTextColor"))
                    .scaleEffect(CGSize(width: 0.7, height: 0.7))
                    .frame(width: 5, height: 5)
            }
            
            if expanded {
                VStack{
                    Text(text)
                        .foregroundColor(Color("lighterTextColor"))
                        .font(.subheadline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                }
                .transition(.push(from: .top))
            }
            
        }
    }
}

#Preview {
    
    HiddenLightSubHeadline(title: "Test", text: "Im expanded!")
}
