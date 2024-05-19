//
//  BoldSubHeadline.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-19.
//

import SwiftUI

struct BoldSubHeadline: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
    }
}

#Preview {
    BoldSubHeadline(text: "test")
}
