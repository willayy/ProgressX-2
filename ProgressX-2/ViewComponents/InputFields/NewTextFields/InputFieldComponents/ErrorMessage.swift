//
//  ErrorMessage.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-09-29.
//

import SwiftUI

struct ErrorMessage: View {
    
    @Binding var message: String
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .fontWeight(.light)
            .foregroundColor(.red)
    }
}

#Preview {
    
    @State var message = "Hello world!"
    
    return ErrorMessage(message: $message)
}
