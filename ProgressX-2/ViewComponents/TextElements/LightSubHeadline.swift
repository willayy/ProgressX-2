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
    let alignment: TextAlignment = .center
    
    var body: some View {
        Text(text)
            .foregroundColor(Color("lighterTextColor"))
            .font(.subheadline)
            .fontWeight(.light)
            .multilineTextAlignment(alignment)
            .minimumScaleFactor(0.5);
    }
}

#Preview {
    LightSubHeadline(text: "test")
}
