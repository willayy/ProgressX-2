//
//  LightSubHeadline.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-19.
//
// This component is an attempt at reducing the amount of source coude lines in swiftUI views.

import SwiftUI

struct LightSubHeadline: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(Color("lightTextColor"))
            .font(.subheadline)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 25)
            .minimumScaleFactor(0.5);
    }
}

#Preview {
    LightSubHeadline(text: "test")
}
