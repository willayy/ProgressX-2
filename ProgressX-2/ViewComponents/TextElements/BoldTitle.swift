//
//  BoldHeadline.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-19.
//
// This component is an attempt at reducing the amount of source coude lines in swiftUI views.

import SwiftUI

struct BoldTitle: View {
    
    let text: String
    let alignment: TextAlignment = .center
    
    var body: some View {
        Text(text)
            .foregroundColor(Color("textColor"))
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .multilineTextAlignment(alignment)
            .minimumScaleFactor(0.5)
    }
}

#Preview {
    BoldTitle(text: "test")
}
