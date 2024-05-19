//
//  BoldHeadline.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-19.
//

import SwiftUI

struct BoldTitle: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .padding()
    }
}

#Preview {
    BoldTitle(text: "test")
}
