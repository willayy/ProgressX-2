//
//  ExpandingTextBox.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-19.
//

import SwiftUI

struct ExpandingVStack<Content: View>: View {
    
    private let title: String
    private var content: Content
    @State private var isExpanded = false
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                Text(title)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            
            if isExpanded {
                VStack {
                    content
                        .frame(maxWidth: .infinity)
                }
                .transition(.move(edge: .bottom))
                .padding(5)
                .background(Color.white.opacity(0.6))
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .animation(.easeInOut, value: isExpanded)
    }
}

#Preview {
    ExpandingVStack(title: "Example", content: {
        Text("Hello this is an example")
        Text("Hello this is an example")
        Text("Hello this is an example")
        Text("Hello this is an example")
        Text("Hello this is an example")
        Text("Hello this is an example")
        Text("Hello this is an example")
        Text("Hello this is an example")
        Text("Hello this is an example")
    })
        .padding(.horizontal, 20)
}
