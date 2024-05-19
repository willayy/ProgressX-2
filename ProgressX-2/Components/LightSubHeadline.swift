//
//  LightSubHeadline.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-19.
//

import SwiftUI

struct LightSubHeadline: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.light)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 25)
            .minimumScaleFactor(0.5);
    }
}

#Preview {
    LightSubHeadline(text: "test")
}
